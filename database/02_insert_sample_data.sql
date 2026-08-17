/* ============================================================
   PROJECT: Oracle Payroll Analytics
   FILE: 02_insert_sample_data.sql
   DESCRIPTION:
   Inserts fictitious sample data for payroll analysis.
   ============================================================ */


/* ============================================================
   1. DEPARTMENTS
   ============================================================ */

INSERT INTO departments (department_name, location)
VALUES ('Finance', 'Mexico City');

INSERT INTO departments (department_name, location)
VALUES ('Human Resources', 'Mexico City');

INSERT INTO departments (department_name, location)
VALUES ('Information Technology', 'Queretaro');

INSERT INTO departments (department_name, location)
VALUES ('Operations', 'Guadalajara');

INSERT INTO departments (department_name, location)
VALUES ('Sales', 'Monterrey');


/* ============================================================
   2. POSITIONS
   ============================================================ */

INSERT INTO positions (position_name, base_salary)
VALUES ('Financial Analyst', 32000);

INSERT INTO positions (position_name, base_salary)
VALUES ('HR Specialist', 28000);

INSERT INTO positions (position_name, base_salary)
VALUES ('Database Developer', 42000);

INSERT INTO positions (position_name, base_salary)
VALUES ('Systems Engineer', 38000);

INSERT INTO positions (position_name, base_salary)
VALUES ('Operations Supervisor', 35000);

INSERT INTO positions (position_name, base_salary)
VALUES ('Sales Executive', 30000);

INSERT INTO positions (position_name, base_salary)
VALUES ('IT Manager', 55000);

/* ============================================================
   3. EMPLOYEES
   ============================================================ */

INSERT INTO employees (
    employee_code,
    first_name,
    last_name,
    email,
    hire_date,
    termination_date,
    employment_status,
    department_id,
    position_id
)
VALUES (
    'EMP001',
    'Ana',
    'Martinez',
    'ana.martinez@example.com',
    DATE '2022-02-14',
    NULL,
    'ACTIVE',
    (SELECT department_id
     FROM departments
     WHERE department_name = 'Finance'),
    (SELECT position_id
     FROM positions
     WHERE position_name = 'Financial Analyst')
);

INSERT INTO employees (
    employee_code,
    first_name,
    last_name,
    email,
    hire_date,
    termination_date,
    employment_status,
    department_id,
    position_id
)
VALUES (
    'EMP002',
    'Carlos',
    'Ramirez',
    'carlos.ramirez@example.com',
    DATE '2021-06-01',
    NULL,
    'ACTIVE',
    (SELECT department_id
     FROM departments
     WHERE department_name = 'Information Technology'),
    (SELECT position_id
     FROM positions
     WHERE position_name = 'Database Developer')
);

INSERT INTO employees (
    employee_code,
    first_name,
    last_name,
    email,
    hire_date,
    termination_date,
    employment_status,
    department_id,
    position_id
)
VALUES (
    'EMP003',
    'Laura',
    'Gomez',
    'laura.gomez@example.com',
    DATE '2023-01-10',
    NULL,
    'ACTIVE',
    (SELECT department_id
     FROM departments
     WHERE department_name = 'Human Resources'),
    (SELECT position_id
     FROM positions
     WHERE position_name = 'HR Specialist')
);

INSERT INTO employees (
    employee_code,
    first_name,
    last_name,
    email,
    hire_date,
    termination_date,
    employment_status,
    department_id,
    position_id
)
VALUES (
    'EMP004',
    'Miguel',
    'Torres',
    'miguel.torres@example.com',
    DATE '2020-09-15',
    NULL,
    'ACTIVE',
    (SELECT department_id
     FROM departments
     WHERE department_name = 'Operations'),
    (SELECT position_id
     FROM positions
     WHERE position_name = 'Operations Supervisor')
);

INSERT INTO employees (
    employee_code,
    first_name,
    last_name,
    email,
    hire_date,
    termination_date,
    employment_status,
    department_id,
    position_id
)
VALUES (
    'EMP005',
    'Sofia',
    'Hernandez',
    'sofia.hernandez@example.com',
    DATE '2024-03-01',
    NULL,
    'ACTIVE',
    (SELECT department_id
     FROM departments
     WHERE department_name = 'Sales'),
    (SELECT position_id
     FROM positions
     WHERE position_name = 'Sales Executive')
);

INSERT INTO employees (
    employee_code,
    first_name,
    last_name,
    email,
    hire_date,
    termination_date,
    employment_status,
    department_id,
    position_id
)
VALUES (
    'EMP006',
    'Jorge',
    'Castillo',
    'jorge.castillo@example.com',
    DATE '2019-04-22',
    DATE '2026-03-31',
    'TERMINATED',
    (SELECT department_id
     FROM departments
     WHERE department_name = 'Information Technology'),
    (SELECT position_id
     FROM positions
     WHERE position_name = 'Systems Engineer')
);

/* ============================================================
   4. PAYROLL PERIODS
   ============================================================ */

INSERT INTO payroll_periods (
    period_code,
    start_date,
    end_date,
    payment_date,
    period_status
)
VALUES (
    '2026-01',
    DATE '2026-01-01',
    DATE '2026-01-31',
    DATE '2026-01-31',
    'PAID'
);

INSERT INTO payroll_periods (
    period_code,
    start_date,
    end_date,
    payment_date,
    period_status
)
VALUES (
    '2026-02',
    DATE '2026-02-01',
    DATE '2026-02-28',
    DATE '2026-02-28',
    'PAID'
);

INSERT INTO payroll_periods (
    period_code,
    start_date,
    end_date,
    payment_date,
    period_status
)
VALUES (
    '2026-03',
    DATE '2026-03-01',
    DATE '2026-03-31',
    DATE '2026-03-31',
    'PAID'
);

INSERT INTO payroll_periods (
    period_code,
    start_date,
    end_date,
    payment_date,
    period_status
)
VALUES (
    '2026-04',
    DATE '2026-04-01',
    DATE '2026-04-30',
    DATE '2026-04-30',
    'PAID'
);

INSERT INTO payroll_periods (
    period_code,
    start_date,
    end_date,
    payment_date,
    period_status
)
VALUES (
    '2026-05',
    DATE '2026-05-01',
    DATE '2026-05-31',
    DATE '2026-05-31',
    'PAID'
);

INSERT INTO payroll_periods (
    period_code,
    start_date,
    end_date,
    payment_date,
    period_status
)
VALUES (
    '2026-06',
    DATE '2026-06-01',
    DATE '2026-06-30',
    DATE '2026-06-30',
    'PAID'
);

/* ============================================================
   5. SALARY HISTORY
   ============================================================ */

INSERT INTO salary_history (
    employee_id,
    effective_date,
    previous_salary,
    new_salary,
    change_reason
)
VALUES (
    (SELECT employee_id
     FROM employees
     WHERE employee_code = 'EMP002'),
    DATE '2025-01-01',
    38000,
    42000,
    'Annual salary adjustment'
);

INSERT INTO salary_history (
    employee_id,
    effective_date,
    previous_salary,
    new_salary,
    change_reason
)
VALUES (
    (SELECT employee_id
     FROM employees
     WHERE employee_code = 'EMP004'),
    DATE '2026-04-01',
    32000,
    35000,
    'Promotion adjustment'
);

INSERT INTO salary_history (
    employee_id,
    effective_date,
    previous_salary,
    new_salary,
    change_reason
)
VALUES (
    (SELECT employee_id
     FROM employees
     WHERE employee_code = 'EMP001'),
    DATE '2026-05-01',
    30000,
    32000,
    'Performance increase'
);

/* ============================================================
   6. PAYROLL
   ============================================================ */

INSERT INTO payroll (
    employee_id,
    period_id,
    gross_salary,
    deductions,
    bonuses,
    net_salary
)
SELECT
    e.employee_id,
    p.period_id,
    CASE e.employee_code
        WHEN 'EMP001' THEN 32000
        WHEN 'EMP002' THEN 42000
        WHEN 'EMP003' THEN 28000
        WHEN 'EMP004' THEN 32000
        WHEN 'EMP005' THEN 30000
        WHEN 'EMP006' THEN 38000
    END,
    CASE e.employee_code
        WHEN 'EMP001' THEN 4200
        WHEN 'EMP002' THEN 5800
        WHEN 'EMP003' THEN 3500
        WHEN 'EMP004' THEN 4300
        WHEN 'EMP005' THEN 3900
        WHEN 'EMP006' THEN 5200
    END,
    CASE e.employee_code
        WHEN 'EMP005' THEN 4500
        ELSE 0
    END,
    CASE e.employee_code
        WHEN 'EMP001' THEN 27800
        WHEN 'EMP002' THEN 36200
        WHEN 'EMP003' THEN 24500
        WHEN 'EMP004' THEN 27700
        WHEN 'EMP005' THEN 30600
        WHEN 'EMP006' THEN 32800
    END
FROM employees e
CROSS JOIN payroll_periods p
WHERE p.period_code = '2026-01';

/* ============================================================
   7. PAYROLL - FEBRUARY TO JUNE 2026
   ============================================================ */

INSERT INTO payroll (
    employee_id,
    period_id,
    gross_salary,
    deductions,
    bonuses,
    net_salary
)
SELECT
    e.employee_id,
    p.period_id,

    CASE
        WHEN e.employee_code = 'EMP004'
             AND p.period_code IN ('2026-04', '2026-05', '2026-06')
            THEN 35000

        WHEN e.employee_code = 'EMP001'
            THEN 32000

        WHEN e.employee_code = 'EMP002'
            THEN 42000

        WHEN e.employee_code = 'EMP003'
            THEN 28000

        WHEN e.employee_code = 'EMP004'
            THEN 32000

        WHEN e.employee_code = 'EMP005'
            THEN 30000

        WHEN e.employee_code = 'EMP006'
            THEN 38000
    END AS gross_salary,

    CASE e.employee_code
        WHEN 'EMP001' THEN 4200
        WHEN 'EMP002' THEN 5800
        WHEN 'EMP003' THEN 3500
        WHEN 'EMP004' THEN 4300
        WHEN 'EMP005' THEN 3900
        WHEN 'EMP006' THEN 5200
    END AS deductions,

    CASE
        WHEN e.employee_code = 'EMP005'
             AND p.period_code = '2026-02'
            THEN 5200

        WHEN e.employee_code = 'EMP005'
             AND p.period_code = '2026-03'
            THEN 6100

        WHEN e.employee_code = 'EMP005'
             AND p.period_code = '2026-04'
            THEN 3800

        WHEN e.employee_code = 'EMP005'
             AND p.period_code = '2026-05'
            THEN 7200

        WHEN e.employee_code = 'EMP005'
             AND p.period_code = '2026-06'
            THEN 6500

        ELSE 0
    END AS bonuses,

    CASE
        WHEN e.employee_code = 'EMP001'
            THEN 27800

        WHEN e.employee_code = 'EMP002'
            THEN 36200

        WHEN e.employee_code = 'EMP003'
            THEN 24500

        WHEN e.employee_code = 'EMP004'
             AND p.period_code IN ('2026-04', '2026-05', '2026-06')
            THEN 30700

        WHEN e.employee_code = 'EMP004'
            THEN 27700

        WHEN e.employee_code = 'EMP005'
             AND p.period_code = '2026-02'
            THEN 31300

        WHEN e.employee_code = 'EMP005'
             AND p.period_code = '2026-03'
            THEN 32200

        WHEN e.employee_code = 'EMP005'
             AND p.period_code = '2026-04'
            THEN 29900

        WHEN e.employee_code = 'EMP005'
             AND p.period_code = '2026-05'
            THEN 33300

        WHEN e.employee_code = 'EMP005'
             AND p.period_code = '2026-06'
            THEN 32600

        WHEN e.employee_code = 'EMP006'
            THEN 32800
    END AS net_salary

FROM employees e
CROSS JOIN payroll_periods p

WHERE p.period_code IN (
    '2026-02',
    '2026-03',
    '2026-04',
    '2026-05',
    '2026-06'
)

AND (
    e.employee_code <> 'EMP006'
    OR p.period_code IN ('2026-02', '2026-03')
);

COMMIT;