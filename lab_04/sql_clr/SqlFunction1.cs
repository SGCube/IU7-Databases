using System;
using System.Collections;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;

public partial class UserDefinedFunctions
{
    [SqlFunction(DataAccess = DataAccessKind.Read)]
    public static int CountOpenedStations()
    {
        using (SqlConnection conn = new SqlConnection("context connection = true"))
        {
            conn.Open();
            SqlCommand cmd = new SqlCommand(" SELECT COUNT(*) AS 'Opened Count' FROM [Stations] WHERE [Station_State] = 'Работает' ", conn);
            return (int)cmd.ExecuteScalar();
        }
    }

    private class CountResult
    {
        public SqlString Model_Name;
        public SqlByte Wagons_Qty;
        public SqlByte Seats_Qty;

        public CountResult(SqlString Name, SqlByte WQTY, SqlByte SQTY)
        {
            Model_Name = Name;
            Wagons_Qty = WQTY;
            Seats_Qty = SQTY;
        }
    }

    [SqlFunction(DataAccess = DataAccessKind.Read, FillRowMethodName = "FillRow",
        TableDefinition = "Model nvarchar(10), Wagons_Qty tinyint, Seats_Qty tinyint")]
    public static IEnumerable DepotMissingTrains(SqlInt32 id)
    {
        ArrayList result = new ArrayList();

        using (SqlConnection connection = new SqlConnection("context connection=true"))
        {
            connection.Open();
            using (SqlCommand selectRows = new SqlCommand(
            "SELECT * FROM [Trains] WHERE [Trains].[Model] NOT IN" +
            " (SELECT [Model_Code] FROM [Stocks] WHERE [Depot_ID] = @id)",
            connection))
            {
                SqlParameter idParam = selectRows.Parameters.Add(
                "@id",
                SqlDbType.Int);
                idParam.Value = id;

                using (SqlDataReader countReader = selectRows.ExecuteReader())
                {
                    while (countReader.Read())
                    {
                        result.Add(new CountResult(
                        countReader.GetSqlString(0),
                        countReader.GetSqlByte(1),
                        countReader.GetSqlByte(2)));
                    }
                }
            }
        }
        return result;
    }

    public static void FillRow(object countResultObj, out SqlString Name, out SqlByte WQty, out SqlByte SQty)
    {
        CountResult tmp = (CountResult)countResultObj;
        Name = tmp.Model_Name;
        WQty = tmp.Wagons_Qty;
        SQty = tmp.Seats_Qty;
    }
}
