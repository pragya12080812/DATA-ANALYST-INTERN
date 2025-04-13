-- Create hospital database
CREATE DATABASE hospital_db;
USE hospital_db;

-- Patients Table
CREATE TABLE patients (
    patient_id INT PRIMARY KEY,
    name VARCHAR(100),
    gender VARCHAR(10),
    dob DATE,
    contact VARCHAR(15)
);

-- Doctors Table
CREATE TABLE doctors (
    doctor_id INT PRIMARY KEY,
    name VARCHAR(100),
    specialty VARCHAR(50)
);

-- Appointments Table
CREATE TABLE appointments (
    appointment_id INT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    appointment_date DATE,
    diagnosis VARCHAR(200),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
);

-- Bills Table
CREATE TABLE bills (
    bill_id INT PRIMARY KEY,
    appointment_id INT,
    amount DECIMAL(10,2),
    payment_status VARCHAR(20),
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id)
);
-- Patients
INSERT INTO patients VALUES
(1, 'Priya Sharma', 'Female', '1990-05-12', '9876543210'),
(2, 'Rahul Verma', 'Male', '1985-11-30', '9123456780'),
(3, 'Anjali Gupta', 'Female', '1995-08-22', '9988776655');

-- Doctors
INSERT INTO doctors VALUES
(101, 'Dr. Mehta', 'Cardiology'),
(102, 'Dr. Roy', 'Neurology'),
(103, 'Dr. Bose', 'Orthopedics');

-- Appointments
INSERT INTO appointments VALUES
(1001, 1, 101, '2023-10-01', 'High BP'),
(1002, 2, 103, '2023-10-03', 'Fracture'),
(1003, 1, 102, '2023-10-10', 'Migraine'),
(1004, 3, 103, '2023-10-12', 'Back Pain');

-- Bills
INSERT INTO bills VALUES
(201, 1001, 1500.00, 'Paid'),
(202, 1002, 2000.00, 'Unpaid'),
(203, 1003, 1800.00, 'Paid'),
(204, 1004, 2200.00, 'Unpaid');
-- 1. Total number of patients
SELECT COUNT(*) AS total_patients FROM patients;

-- 2. Total revenue generated
SELECT SUM(amount) AS total_revenue FROM bills WHERE payment_status = 'Paid';

-- 3. Unpaid bills
SELECT * FROM bills WHERE payment_status = 'Unpaid';

-- 4. Appointments per doctor
SELECT d.name AS doctor, COUNT(a.appointment_id) AS total_appointments
FROM doctors d
JOIN appointments a ON d.doctor_id = a.doctor_id
GROUP BY d.name;

-- 5. Most frequent patient (by appointment count)
SELECT p.name, COUNT(a.appointment_id) AS visit_count
FROM appointments a
JOIN patients p ON a.patient_id = p.patient_id
GROUP BY p.name
ORDER BY visit_count DESC
LIMIT 1;

-- 6. Patients who visited more than once
SELECT patient_id, COUNT(*) AS visits
FROM appointments
GROUP BY patient_id
HAVING visits > 1;

-- 7. Diagnosis and payment info
SELECT p.name, a.diagnosis, b.amount, b.payment_status
FROM appointments a
JOIN patients p ON a.patient_id = p.patient_id
JOIN bills b ON a.appointment_id = b.appointment_id;