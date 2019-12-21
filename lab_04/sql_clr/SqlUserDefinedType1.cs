using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;
using System.Text;


[Serializable]
[Microsoft.SqlServer.Server.SqlUserDefinedType(Format.Native)]
public struct Vertex: INullable
{
    public override string ToString()
    {
        if (this.IsNull)
            return "NULL";
        else
        {
            StringBuilder builder = new StringBuilder();
            builder.Append(_x);
            builder.Append(", ");
            builder.Append(_y);
            builder.Append(", ");
            builder.Append(_z);
            return builder.ToString();
        }

    }

    public bool IsNull
    {
        get
        {
            return _null;
        }
    }
    
    public static Vertex Null
    {
        get
        {
            Vertex h = new Vertex();
            h._null = true;
            return h;
        }
    }
    
    public static Vertex Parse(SqlString s)
    {
        if (s.IsNull)
            return Null;

        Vertex u = new Vertex();
        string[] xyz = s.Value.Split(",".ToCharArray());
        u._x = Int32.Parse(xyz[0]);
        u._y = Int32.Parse(xyz[1]);
        u._y = Int32.Parse(xyz[2]);

        return u;
    }

    public Int32 x
    {
        get
        {
            return this._x;
        }

        set
        {
            _x = value;
        }
    }

    public Int32 y
    {
        get
        {
            return this._y;
        }

        set
        {
            _y = value;
        }
    }

    public Int32 z
    {
        get
        {
            return this._z;
        }

        set
        {
            _z = value;
        }
    }

    [SqlMethod(OnNullCall = false)]
    public Double Distance()
    {
        return DistanceFromXY(0, 0);
    }

    [SqlMethod(OnNullCall = false)]
    public Double DistanceFrom(Vertex pFrom)
    {
        return DistanceFromXY(pFrom.x, pFrom.y);
    }

    [SqlMethod(OnNullCall = false)]
    public Double DistanceFromXY(Int32 iX, Int32 iY)
    {
        return Math.Sqrt(Math.Pow(iX - _x, 2.0) + Math.Pow(iY - _y, 2.0));
    }

    // Закрытый член
    private bool _null;
    private Int32 _x, _y, _z;
}