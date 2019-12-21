using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;

[Serializable]
[Microsoft.SqlServer.Server.SqlUserDefinedAggregate(Format.Native)]
public struct CountNotLess10
{
    private int count;

    public void Init()
    {
        count = 0;
    }

    public void Accumulate(SqlInt32 Value)
    {
        if (Value > 9)
        {
            count++;
        }
    }

    public void Merge (CountNotLess10 Group)
    {
        count += Group.count;
    }

    public SqlInt32 Terminate ()
    {
        return new SqlInt32(count);
    }

}
