Create database hospital_management1;
use hospital_management1;


Create table departments (
department_id Int primary key auto_increment,
department_name VARCHAR(100) NOT NULL,
location Varchar(100)
);

Create table doctors (
doctor_id Int Primary key auto_increment,
first_name Varchar(50),
last_name Varchar(50),
specialization VARCHAR(100),
department_id INT, 
experience_years INT,
foreign key(department_id) references departments(department_id)
);

Create Table patients (
patient_id Int Primary key auto_increment,
first_name Varchar(50),
last_name Varchar(50),
Gender Varchar(10),
date_of_birth date,
phone varchar(15),
city varchar(50),
registration_date Date
);

CREATE TABLE appointments ( 
appointment_id INT PRIMARY KEY AUTO_INCREMENT, 
patient_id INT, 
doctor_id INT, 
appointment_date DATE,
appointment_status varchar(30),
foreign key (patient_id) references patients(patient_id),
foreign key (doctor_id) references doctors(doctor_id)
);

CREATE TABLE admissions ( 
admission_id INT PRIMARY KEY AUTO_INCREMENT, 
patient_id INT, 
admission_date DATE, 
discharge_date DATE, 
room_number VARCHAR(10), 
FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
);

CREATE TABLE treatments ( 
treatment_id INT PRIMARY KEY AUTO_INCREMENT, 
admission_id INT, 
doctor_id INT, 
diagnosis VARCHAR(200), 
treatment_cost DECIMAL(10,2), 
FOREIGN KEY (admission_id) REFERENCES admissions(admission_id), 
FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id) 
);

CREATE TABLE medical_tests ( 
test_id INT PRIMARY KEY AUTO_INCREMENT, 
patient_id INT, test_name VARCHAR(100), 
test_date DATE, test_result VARCHAR(100), 
test_cost DECIMAL(10,2), 
FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
);

CREATE TABLE billing ( 
bill_id INT PRIMARY KEY AUTO_INCREMENT, 
patient_id INT, 
total_amount DECIMAL(10,2), 
payment_status VARCHAR(30), 
bill_date DATE, 
FOREIGN KEY (patient_id) REFERENCES patients(patient_id) 
);

INSERT INTO departments (department_name, location) VALUES
('Cardiology','Block A'),
('Orthopedics','Block B'),
('Neurology','Block C');

insert Into doctors (first_name,last_name,specialization,department_id,experience_years) values
('Rahul', 'Mehta', 'Cardiologist', 1, 10), 
('Priya', 'Sharma', 'Orthopedic Surgeon', 2, 8), 
('Amit', 'Verma', 'Neurologist', 3, 12);

INSERT INTO patients (first_name, last_name, gender, date_of_birth, phone, city, registration_date) VALUES 
('Raj', 'Kumar', 'Male', '1990-05-10', '9876543210', 'Delhi', '2025-01-01'), 
('Anita', 'Singh', 'Female', '1985-08-15', '9123456780', 'Mumbai', '2025-01-10'), 
('Suresh', 'Yadav', 'Male', '1978-03-20', '9988776655', 'Lucknow', '2025-01-15');

INSERT INTO appointments (patient_id, doctor_id, appointment_date, appointment_status) VALUES 
(1, 1, '2025-02-01', 'Completed'), 
(2, 2, '2025-02-03', 'Completed'), 
(3, 3, '2025-02-05', 'Pending');

INSERT INTO admissions (patient_id, admission_date, discharge_date, room_number)
 VALUES (1, '2025-02-01', '2025-02-05', '101A'), 
 (2, '2025-02-03', '2025-02-06', '202B');
 
 INSERT INTO treatments (admission_id, doctor_id, diagnosis, treatment_cost) VALUES 
 (1, 1, 'Heart Surgery', 150000), 
 (2, 2, 'Fracture Treatment', 50000);
 
 INSERT INTO medical_tests (patient_id, test_name, test_date, test_result, test_cost) 
 VALUES (1, 'ECG', '2025-02-01', 'Normal', 2000), 
 (2, 'X-Ray', '2025-02-03', 'Minor Fracture', 1500), 
 (3, 'MRI', '2025-02-05', 'Under Review', 5000);
 
 INSERT INTO billing (patient_id, total_amount, payment_status, bill_date) VALUES 
 (1, 152000, 'Paid', '2025-02-05'), 
 (2, 51500, 'Pending', '2025-02-06');
 
 -- MEDICAL ANALYTICS QUERIES
 
 -- 1.Total Revenue Generated
 Select sum(total_amount) As hospital_revenue
 from billing;
 
 -- 2.Number of Patients per Department

select d.department_name,
count(a.appointment_id) as total_patients
from departments d
join doctors doc on d.department_id = doc.department_id
join appointments a on doc.doctor_id = doc.doctor_id
group by d.department_name;
 
 -- 3.Doctor Performance (Revenue Generated)
 
 select d.first_name ,sum(t.treatment_cost) As revenue_generated
 from doctors d 
 join treatments t on d.doctor_id = t.doctor_id
 group by d.first_name
 order by revenue_generated desc;
 
 -- 4.Average Treatment Cost

select avg(treatment_cost) as Avg_Treatment_Cost
from treatments;

-- 5.Patients with Pending Bills
select * from billing;
select * from patients;

select DISTINCT p.first_name,b.total_amount 
from patients p 
join billing b on p.patient_id = b.patient_id
where b.payment_status = 'Pending';

-- Create View

Create View patient_summary As
select p.patient_id,p.first_name,
count(a.appointment_id) as total_appointments
from patients p
left join appointments a on p.patient_id = a.patient_id
Group by p.patient_id,p.first_name;

select * from patient_summary;

-- STEP 6 — STORED PROCEDURE (Patient History)

Delimiter //

Create Procedure getpatienthistory(In pid int)
Begin
  Select * from appointments where patient_id= pid;
  select * from medical_tests where patient_id= pid;
End //

Delimiter ;

call getpatienthistory(3);


