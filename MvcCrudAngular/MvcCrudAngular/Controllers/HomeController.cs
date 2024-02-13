

using MvcCrudAngular.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Web.Mvc;

namespace MvcCrudAngular.Controllers
{
    public class HomeController : Controller
    {
        //
        // GET: /Home/
        EmployeeDAL dblayer = new EmployeeDAL();
        public ActionResult Index()
        {
            return View();
        }

        //public ActionResult Create()
        //{
        //    return View();
        //}
        //public ActionResult Edit()
        //{
        //    return View();
        //}
     

        [HttpPost]

        public JsonResult Create(Employee rs)
        {

            string res = string.Empty;

            try
            {
                dblayer.InsertEmployee(rs);
                res = "Successfully Inserted...!";
            }

                catch (Exception)
            {

                res = "Failed";

            }

            return Json(res, JsonRequestBehavior.AllowGet);

        }

        [HttpPost]

        public JsonResult Edit(int id, Employee rs)
        {
            string res = string.Empty;
            try
            {
                dblayer.UpdateEmployee(id,rs);
                res = "Successfully Updated...!";
            }

            catch (Exception)
            {

                res = "Failed";

            }

            return Json(res, JsonRequestBehavior.AllowGet);

        }



        public JsonResult GetAllEmployees()
        {
            DataSet ds = dblayer.GetAllEmployees();
            List<Employee> listrs = new List<Employee>();

            foreach (DataRow dr in ds.Tables[0].Rows)
            {
                Employee employee = new Employee
                {
                    Id = (int)dr["Id"],
                    Name = dr["Name"].ToString(),
                    Email = dr["Email"].ToString(),
                    Gender = dr["Gender"].ToString(),
                    CountryId = (int)dr["CountryId"],
                    CountryName = dr["CountryName"].ToString(),
                    StateId = (int)dr["StateId"],
                    StateName = dr["StateName"].ToString()
                };

                // Check for DBNull.Value before attempting to convert
                if (dr["ImageData"] != DBNull.Value)
                {
                    // Directly assign the byte array
                    byte[] imageData = (byte[])dr["ImageData"];
                    employee.ImageData = imageData;
                }
                else
                {
                    employee.ImageData = null;
                }

                listrs.Add(employee);
            }

            return Json(listrs, JsonRequestBehavior.AllowGet);
        }

        [HttpGet]
        public ActionResult GetImage(int id)
        {
            byte[] imageData = dblayer.GetImageDataById(id);

            if (imageData != null)
            {
                return File(imageData, "image/jpeg"); // Adjust content type based on your image type
            }
            else
            {
                return HttpNotFound("Image not found");
            }
        }


        public JsonResult GetCountries()
        {

            DataSet ds = dblayer.GetCountries();

            List<Country> listrs = new List<Country>();

            foreach (DataRow dr in ds.Tables[0].Rows)
            {

                listrs.Add(new Country

                {
                    CountryId = (int)dr["CountryId"],
                    CountryName = dr["CountryName"].ToString()

                });

            }

            return Json(listrs, JsonRequestBehavior.AllowGet);

        }
        public JsonResult GetStates(int id)
        {

            DataSet ds = dblayer.GetStates(id);

            List<State> listrs = new List<State>();

            foreach (DataRow dr in ds.Tables[0].Rows)
            {

                listrs.Add(new State

                {
                    StateId = (int)dr["StateId"],
                    StateName = dr["StateName"].ToString()

                });

            }

            return Json(listrs, JsonRequestBehavior.AllowGet);

        }



        public JsonResult DeleteEmployee(int id)
        {
            string res = string.Empty;
            try
            {
             dblayer.DeleteEmployee(id);
                res = "data deleted";
            }
            catch (Exception)
            {
                res = "failed";
            }
            return Json(res, JsonRequestBehavior.AllowGet);
        }

       
    }
}
