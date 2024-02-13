

var app = angular.module('employeeApp', []);

app.controller('employeeController', function ($scope, $http) {

  
    $scope.currentView = 'list'; // Default view

    $scope.changeView = function (view) {
        $scope.currentView = view;
    };


    $scope.getEmployees = function () {
        $http.get("/Home/GetAllEmployees").then(function (response) {
            $scope.employees = response.data;
        }, function (error) {
            alert('Failed');
        });
    };
    $scope.getEmployees();

    $scope.getEmployeeStates = function (cid) {
        $http.get("/Home/GetStates?id=" + cid).then(function (response) {
            $scope.states = response.data;  // Update the countries array
        }, function (error) {
            alert('Failed');
        });
    };

    $scope.getEmployeeCountries = function () {
        $http.get("/Home/GetCountries").then(function (response) {
            $scope.countries = response.data;  // Update the countries array
        }, function (error) {
            alert('Failed');
        });
    };


    $scope.employee = {};

    $scope.createEmployee = function () {
        var fileInput = document.getElementById('imageFile');
        var file = fileInput.files[0];

        var imageData = null; // Initialize with null

        if (file) {
            var reader = new FileReader();

            reader.onloadend = function () {
                imageData = reader.result.split(',')[1]; // Extract base64 data
                submitEmployeeData();
            };

            reader.readAsDataURL(file);
        } else {
            // No image selected, submit with imageData as null
            submitEmployeeData();
        }

        function submitEmployeeData() {
            var employeeData = {
                Name: $scope.employee.Name,
                Email: $scope.employee.Email,
                Gender: $scope.employee.Gender,
                CountryId: $scope.employee.CountryId,
                StateId: $scope.employee.StateId,
                ImageData: imageData
            };

            $http.post("/Home/Create", employeeData)
                .then(function (response) {
                    $scope.getEmployees();
                    alert('Data Submitted...!');
                    $scope.employee = {};
                    $scope.currentView = 'list';
                })
                .catch(function (error) {
                    alert('Failed to add employee.');
                });
        }
    };



       
  
    $scope.tempEmpId = null;
   
    $scope.update = function (employee) {
        // Set the employee details for editing
        $scope.editEmployee = angular.copy(employee);
        console.log($scope.editEmployee); // Add this line
        $scope.tempEmpId = angular.copy(employee.Id);
        console.log($scope.tempEmpId);
    }; 
   
    $scope.updateEmployee = function (tempEmpId) {
        var fileInput = document.getElementById('imageUpdateFile');
        var file = fileInput.files[0];

        var imageData = null; // Initialize with null

        if (file) {
            var reader = new FileReader();

            reader.onloadend = function () {
                imageData = reader.result.split(',')[1]; // Extract base64 data
                submitEmployeeData(tempEmpId);
            };

            reader.readAsDataURL(file);
        } else {
            // No image selected, submit with imageData as null
            submitEmployeeData();
        }

        function submitEmployeeData(tempEmpId) {
            var employeeData = {
                Id: $scope.tempEmpId, // Make sure to include the employee Id
                Name: $scope.editEmployee.Name,
                Email: $scope.editEmployee.Email,
                Gender: $scope.editEmployee.Gender,
                CountryId: $scope.editEmployee.CountryId,
                StateId: $scope.editEmployee.StateId,
                ImageData: imageData
            };
            debugger;
            $http.post("/Home/Edit?id=" + tempEmpId, employeeData)
                .then(function (response) {
                    $scope.getEmployees();
                    alert('Data Submitted...!');
                    $scope.employee = {};
                    $scope.currentView = 'list';
                })
                .catch(function (error) {
                    alert('Failed to update employee.');
                });
        }
    };


    $scope.deleteEmployee = function (id) {
       var confirmDelete = window.confirm('Are you sure you want to delete this employee?');

        // If the user clicks "OK," proceed with the delete operation
        if (confirmDelete) {
            $http.get("/Home/DeleteEmployee?id=" + id).then(function (response) {
                alert(response.data);
                $scope.getEmployees(); // Update the employee list
            }, function (error) {
                alert('Failed to delete employee.');
            });
        } else {
            // If the user clicks "Cancel," do nothing or handle accordingly
            alert('Delete operation canceled.');
        }
    };
     
    // Call the function to get countries when the controller loads
    $scope.getEmployeeCountries();
    $scope.getEmployees(); 


    $scope.viewImage = function (employee) {
        if (employee && employee.Id) {
            var imageUrl = "/Home/GetImage?id=" + employee.Id;

            $http.get(imageUrl, { responseType: 'arraybuffer' })
                .then(function (response) {
                    var blob = new Blob([response.data], { type: 'image/jpeg' });
                    var imageUrl = URL.createObjectURL(blob);

                    // Open the image in a new window or display it in your UI
                    window.open(imageUrl, 'View Image', 'width=500,height=400');
                })
                .catch(function (error) {
                    console.error('Failed to retrieve image data.', error);
                });
        }
    };


    $scope.downloadImage = function (employee) {
        if (employee && employee.Id) {
            var imageUrl = "/Home/GetImage?id=" + employee.Id;

            $http.get(imageUrl, { responseType: 'arraybuffer' })
                .then(function (response) {
                    var blob = new Blob([response.data], { type: 'image/jpeg' });

                    // Trigger download
                    var link = document.createElement('a');
                    link.href = URL.createObjectURL(blob);
                    link.download = 'employee_image.jpg'; // Adjust the file name as needed

                    // Forcing a click event to trigger the download prompt
                    var clickEvent = new MouseEvent('click', {
                        bubbles: true,
                        cancelable: true,
                        view: window
                    });

                    link.dispatchEvent(clickEvent);

                    // Cleanup
                    URL.revokeObjectURL(link.href);
                })
                .catch(function (error) {
                    console.error('Failed to retrieve image data.', error);
                });
        }
    };


    // Other controller logic can be added here
});


