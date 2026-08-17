/* ============================================================
   PROJECT: Oracle Payroll Analytics
   FILE: 03_employee_status_analysis.sql
   DESCRIPTION:
   Employee status, termination and payroll audit analysis.
   ============================================================ */


/* ============================================================
   1. EMPLOYEE STATUS SUMMARY
   ============================================================ */

SELECT
    employment_status,
    COUNT(*) AS total_employees
FROM employees
GROUP BY employment_status
ORDER BY employment_status;

/* ============================================================
   2. TERMINATED EMPLOYEES
   ============================================================ */

SELECT
    e.employee_code,
    e.first_name,
    e.last_name,
    d.department_name,
    p.position_name,
    e.hire_date,
    e.termination_date,
    e.employment_status,

    ROUND(
        MONTHS_BETWEEN(
            e.termination_date,
            e.hire_date
        ),
        1
    ) AS months_employed

FROM employees e

JOIN departments d
    ON d.department_id = e.department_id

JOIN positions p
    ON p.position_id = e.position_id

WHERE e.termination_date IS NOT NULL

ORDER BY e.termination_date;

* ============================================================
   3. PAYMENTS AFTER TERMINATION DATE
   ============================================================ */

SELECT
    e.employee_code,
    e.first_name,
    e.last_name,
    e.termination_date,
    pp.period_code,
    pp.payment_date,
    p.gross_salary,
    p.bonuses,
    p.deductions,
    p.net_salary

FROM payroll p

JOIN employees e
    ON e.employee_id = p.employee_id

JOIN payroll_periods pp
    ON pp.period_id = p.period_id

WHERE e.termination_date IS NOT NULL
  AND pp.payment_date > e.termination_date

ORDER BY
    e.employee_code,
    pp.payment_date;

/* ============================================================
   4. PAYROLL RECORDS BY EMPLOYMENT STATUS
   ============================================================ */

SELECT
    e.employment_status,
    COUNT(p.payroll_id) AS payroll_records,
    SUM(p.gross_salary) AS total_gross_salary,
    SUM(p.net_salary) AS total_net_salary

FROM employees e

LEFT JOIN payroll p
    ON p.employee_id = e.employee_id

GROUP BY e.employment_status

ORDER BY e.employment_status;

/* ============================================================
   5. LAST PAYROLL PAYMENT PER EMPLOYEE
   ============================================================ */

WITH employee_payments AS (
    SELECT
        e.employee_id,
        e.employee_code,
        e.first_name,
        e.last_name,
        e.employment_status,
        e.termination_date,

        pp.period_code,
        pp.payment_date,

        p.net_salary,

        ROW_NUMBER() OVER (
            PARTITION BY e.employee_id
            ORDER BY pp.payment_date DESC
        ) AS rn

    FROM employees e

    LEFT JOIN payroll p
        ON p.employee_id = e.employee_id

    LEFT JOIN payroll_periods pp
        ON pp.period_id = p.period_id
)

SELECT
    employee_code,
    first_name,
    last_name,
    employment_status,
    termination_date,
    period_code AS last_period_paid,
    payment_date AS last_payment_date,
    net_salary AS last_net_salary

FROM employee_payments

WHERE rn = 1

ORDER BY employee_code;