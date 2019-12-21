using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;

public partial class StoredProcedures
{
    [Microsoft.SqlServer.Server.SqlProcedure]
    public static void AddTrainsToStocks(string model, SqlInt32 amount)
    {
        using (SqlConnection contextConnection = new SqlConnection("context connection = true"))
        {
            SqlCommand contextCommandU = new SqlCommand(
                "UPDATE Stocks", 
                contextConnection);
            SqlCommand contextCommand = new SqlCommand(
                "SET Qty = Qty + @Amount WHERE Model_Code = @Model", 
                contextConnection);
            contextCommand.Parameters.AddWithValue("@Amount", amount);
            contextCommand.Parameters.AddWithValue("@Model", model);
            contextConnection.Open();

            SqlContext.Pipe.ExecuteAndSend(contextCommand);
        }

    }
}
