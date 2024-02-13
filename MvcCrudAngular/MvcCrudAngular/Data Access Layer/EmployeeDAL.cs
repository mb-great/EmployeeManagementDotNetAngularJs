using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace MvcCrudAngular.Models
{
    public class EmployeeDAL
    {
        readonly SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString);



        public void InsertEmployee(Employee rs)
        {
            SqlCommand com = new SqlCommand("InsertEmployee", con);
            com.CommandType = CommandType.StoredProcedure;

            com.Parameters.AddWithValue("@Name", rs.Name);
            com.Parameters.AddWithValue("@Email", rs.Email);
            com.Parameters.AddWithValue("@Gender", rs.Gender);
            com.Parameters.AddWithValue("@CountryId", rs.CountryId);
            com.Parameters.AddWithValue("@StateId", rs.StateId);

            // Check if ImageData is not null before adding it to parameters
            if (rs.ImageData != null && rs.ImageData.Length > 0)
            {
                com.Parameters.AddWithValue("@ImageData", rs.ImageData);
            }
            else
            {
                com.Parameters.Add("@ImageData", SqlDbType.VarBinary).Value = DBNull.Value;
            }

            con.Open();
            com.ExecuteNonQuery();
            con.Close();  
        }


        public DataSet GetAllEmployees()
        {
            SqlCommand com = new SqlCommand("GetAllEmployees", con);
            com.CommandType = CommandType.StoredProcedure;

            SqlDataAdapter da = new SqlDataAdapter(com);
            DataSet ds = new DataSet();
            da.Fill(ds);

            return ds;
        }

        public DataSet GetCountries()
        {
            SqlCommand com = new SqlCommand("GetAllCountriesForDropdown", con);
            com.CommandType = CommandType.StoredProcedure;

            SqlDataAdapter da = new SqlDataAdapter(com);
            DataSet ds = new DataSet();
            da.Fill(ds);
            return ds;
        }
        public DataSet GetStates(int id)
        {
            SqlCommand com = new SqlCommand("GetAllStatesForDropdown", con);
            com.CommandType = CommandType.StoredProcedure;
            com.Parameters.AddWithValue("@CountryID", id);
            SqlDataAdapter da = new SqlDataAdapter(com);
            DataSet ds = new DataSet();
            da.Fill(ds);
            return ds;
        }

        public byte[] GetImageDataById(int id)
        {
            SqlCommand com = new SqlCommand("GetImageDataById", con); // Assuming you have a stored procedure for retrieving image data
            com.CommandType = CommandType.StoredProcedure;
            com.Parameters.AddWithValue("@Id", id);

            con.Open();

            byte[] imageData = (byte[])com.ExecuteScalar();

            con.Close();

            return imageData;
        }


        public void DeleteEmployee(int id)
        {

            SqlCommand com = new SqlCommand("DeleteEmployee", con);

            com.CommandType = CommandType.StoredProcedure;

            com.Parameters.AddWithValue("@EmployeeId", id);

            con.Open();

            com.ExecuteNonQuery();

            con.Close();

        }

        public void UpdateEmployee(int id, Employee rs)
        {
            SqlCommand com = new SqlCommand("UpdateEmployee", con);
            com.CommandType = CommandType.StoredProcedure;
            com.Parameters.AddWithValue("@Id", id);
            com.Parameters.AddWithValue("@Name", rs.Name);
            com.Parameters.AddWithValue("@Email", rs.Email);
            com.Parameters.AddWithValue("@Gender", rs.Gender);
            com.Parameters.AddWithValue("@CountryId", rs.CountryId);
            com.Parameters.AddWithValue("@StateId", rs.StateId);
            // Check if ImageData is not null before adding it to parameters
            if (rs.ImageData != null && rs.ImageData.Length > 0)
            {
                com.Parameters.AddWithValue("@ImageData", rs.ImageData);
            }
            else
            {
                com.Parameters.Add("@ImageData", SqlDbType.VarBinary).Value = DBNull.Value;
            }


            con.Open();
            com.ExecuteNonQuery();
            con.Close();
        }


        public DataSet GetEmployeeById(int id)
        {

            SqlCommand com = new SqlCommand("GetEmployeeById", con);

            com.CommandType = CommandType.StoredProcedure;

            com.Parameters.AddWithValue("@Id", id);

            SqlDataAdapter da = new SqlDataAdapter(com);

            DataSet ds = new DataSet();

            da.Fill(ds);

            return ds;

        }


    }
}