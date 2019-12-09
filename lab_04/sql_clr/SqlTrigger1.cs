using System;
using System.Data;
using System.Data.SqlClient;
using Microsoft.SqlServer.Server;

public partial class Triggers
{
    // [Microsoft.SqlServer.Server.SqlTrigger(Name="NoLineDelete", Target="[Lines]", Event="FOR UPDATE")]
    public static void T_NoLineDelete()
    {
        SqlTriggerContext triggerContext = SqlContext.TriggerContext;
        if (triggerContext.TriggerAction == TriggerAction.Delete)
            SqlContext.Pipe.Send("You can't delete lines.");
    }
}

