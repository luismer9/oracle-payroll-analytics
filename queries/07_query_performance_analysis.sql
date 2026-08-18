/* ============================================================
   PROJECT: Oracle Payroll Analytics
   FILE: 07_query_performance_analysis.sql
   DESCRIPTION:
   Demonstrates execution-plan analysis and index usage
   for common payroll queries.
   ============================================================ */


/* ============================================================
   1. VERIFY AVAILABLE INDEXES
   ============================================================ */

SELECT
    index_name,
    table_name,
    uniqueness,
    status
FROM user_indexes
WHERE table_name IN (
    'EMPLOYEES',
    'PAYROLL',
    'PAYROLL_PERIODS',
    'SALARY_HISTORY'
)
ORDER BY
    table_name,
    index_name;


/* ============================================================
   2. EMPLOYEE PAYROLL LOOKUP
   ============================================================ */

EXPLAIN PLAN FOR
SELECT
    p.payroll_id,
    p.employee_id,
    p.period_id,
    p.gross_salary,
    p.bonuses,
    p.deductions,
    p.net_salary
FROM payroll p
WHERE p.employee_id = 2;

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);


/* ============================================================
   3. EMPLOYEE STATUS FILTER
   ============================================================ */

EXPLAIN PLAN FOR
SELECT
    e.employee_code,
    e.first_name,
    e.last_name,
    e.employment_status
FROM employees e
WHERE e.employment_status = 'TERMINATED';

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);


/* ============================================================
   4. PAYROLL PERIOD LOOKUP
   ============================================================ */

EXPLAIN PLAN FOR
SELECT
    p.payroll_id,
    p.employee_id,
    p.net_salary
FROM payroll p
WHERE p.period_id = 3;

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);


/* ============================================================
   5. SALARY HISTORY LOOKUP
   ============================================================ */

EXPLAIN PLAN FOR
SELECT
    sh.employee_id,
    sh.effective_date,
    sh.previous_salary,
    sh.new_salary,
    sh.change_reason
FROM salary_history sh
WHERE sh.employee_id = 2
ORDER BY sh.effective_date;

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);


/* ============================================================
   6. PAYROLL REPORT WITH JOINS
   ============================================================ */

EXPLAIN PLAN FOR
SELECT
    e.employee_code,
    e.first_name,
    e.last_name,
    d.department_name,
    pp.period_code,
    p.net_salary

FROM payroll p

JOIN employees e
    ON e.employee_id = p.employee_id

JOIN departments d
    ON d.department_id = e.department_id

JOIN payroll_periods pp
    ON pp.period_id = p.period_id

WHERE pp.period_code = '2026-03'

ORDER BY e.employee_code;

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);