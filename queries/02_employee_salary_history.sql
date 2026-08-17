/* ============================================================
   PROJECT: Oracle Payroll Analytics
   FILE: 02_employee_salary_history.sql
   DESCRIPTION:
   Employee salary history and salary change analysis.
   ============================================================ */


/* ============================================================
   1. SALARY HISTORY DETAIL
   ============================================================ */

SELECT
    e.employee_code,
    e.first_name,
    e.last_name,
    sh.effective_date,
    sh.previous_salary,
    sh.new_salary,
    sh.new_salary - sh.previous_salary AS salary_increase,

    ROUND(
        (
            sh.new_salary - sh.previous_salary
        )
        / NULLIF(sh.previous_salary, 0)
        * 100,
        2
    ) AS increase_percentage,

    sh.change_reason

FROM salary_history sh

JOIN employees e
    ON e.employee_id = sh.employee_id

ORDER BY
    e.employee_code,
    sh.effective_date;

/* ============================================================
   2. LATEST SALARY CHANGE PER EMPLOYEE
   ============================================================ */

WITH salary_changes AS (
    SELECT
        e.employee_code,
        e.first_name,
        e.last_name,
        sh.effective_date,
        sh.previous_salary,
        sh.new_salary,
        sh.change_reason,

        ROW_NUMBER() OVER (
            PARTITION BY e.employee_id
            ORDER BY sh.effective_date DESC
        ) AS rn

    FROM salary_history sh

    JOIN employees e
        ON e.employee_id = sh.employee_id
)

SELECT
    employee_code,
    first_name,
    last_name,
    effective_date,
    previous_salary,
    new_salary,
    new_salary - previous_salary AS salary_increase,

    ROUND(
        (
            new_salary - previous_salary
        )
        / NULLIF(previous_salary, 0)
        * 100,
        2
    ) AS increase_percentage,

    change_reason

FROM salary_changes

WHERE rn = 1

ORDER BY employee_code;

/* ============================================================
   3. SALARY CHANGE TREND
   ============================================================ */

WITH salary_timeline AS (
    SELECT
        e.employee_code,
        e.first_name,
        e.last_name,
        sh.effective_date,
        sh.new_salary,

        LAG(sh.new_salary) OVER (
            PARTITION BY e.employee_id
            ORDER BY sh.effective_date
        ) AS previous_recorded_salary

    FROM salary_history sh

    JOIN employees e
        ON e.employee_id = sh.employee_id
)

SELECT
    employee_code,
    first_name,
    last_name,
    effective_date,
    previous_recorded_salary,
    new_salary,

    new_salary - previous_recorded_salary
        AS salary_difference

FROM salary_timeline

ORDER BY
    employee_code,
    effective_date;