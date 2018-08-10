using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;


namespace WebApplication5
{
    public class Handler1 : IHttpHandler
    {
        public void ProcessRequest(HttpContext context)
        {
            SqlConnection conn = new SqlConnection("Data Source=DESKTOP-3TVI1GN\\SQLEXPRESS;Initial Catalog=MapApplication;Integrated Security=True");//Sql bağlantısı
            conn.Open();
            SqlCommand cmd = conn.CreateCommand();

            var function = context.Request.QueryString["f"];
            string districtName = "";
            string districtWkt = "";
            string responce = "";
            string districtCode = "";
            string placeNo = "";
            string placeCoord = "";
            switch (function)
            {
                case "AddDistrict":
                    districtName = context.Request.QueryString["Mahalle_Adi"];
                    districtWkt = context.Request.QueryString["Koordinatlar"];
                    districtCode = context.Request.QueryString["Mahalle_kodu"];
                    cmd.CommandText = "insert into Mahalle (Mahalle_Adi,Koordinatlar,Mahalle_kodu)Values('" + districtName + "','" + districtWkt + "','" + districtCode + "')";//Mahalle ekleme
                    int sonuc = cmd.ExecuteNonQuery();
                    if (sonuc > 0)
                        responce = districtName + " Başarıyla eklendi.";
                    else
                        responce += "Error";
                    cmd.Dispose();
                    conn.Close();
                    break;
                case "GetDistricts":
                    cmd.CommandText = "Select * from Mahalle";//Mahalle seçme
                    SqlDataAdapter adp = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable("Distincs");
                    adp.Fill(dt);
                    adp.Dispose();
                    cmd.Dispose();
                    conn.Close();
                    responce = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
                    break;
                case "AddPlace"://Kapı Ekleme
                    districtCode = context.Request.QueryString["Mahalle_kodu"];
                    placeNo = context.Request.QueryString["kapi_no"];
                    placeCoord = context.Request.QueryString["Koordinatlar"];
                    cmd.CommandText = "insert into Kapi(kapi_no,Koordinatlar,Mahalle_kodu)Values('" + placeNo + "','" + placeCoord + "','" + districtCode + "')";
                    int sonucKapi = cmd.ExecuteNonQuery();
                    if (sonucKapi > 0)
                        responce = "kapı no: " + placeNo + " Başarıyla eklendi. mahalle kodu: " + districtCode;
                    else
                    responce += "Error";
                    cmd.Dispose();
                    conn.Close();
                    break;
                case "GetPlaces"://Kapı Seçme
                    cmd.CommandText = "Select * from Kapi";
                    SqlDataAdapter adpKapi = new SqlDataAdapter(cmd);
                    DataTable dtKapi = new DataTable("Places");
                    adpKapi.Fill(dtKapi);
                    adpKapi.Dispose();
                    cmd.Dispose();
                    conn.Close();
                    responce = Newtonsoft.Json.JsonConvert.SerializeObject(dtKapi);
                    break;
                default:
                    break;              
            }
            context.Response.ContentType = "text/html";
            context.Response.Write(responce);
        }
        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}