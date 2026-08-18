/* ============================================================
   PROJECT: Oracle Payroll Analytics
   FILE: 01_employee_payroll_summary.sql
   DESCRIPTION:
   Creates a reusable view combining employee, department,
   position, payroll and payroll-period information.
   ============================================================ */

CREATE OR REPLACE VIEW vw_employee_payroll_summary AS

SELECT
    e.employee_id,
    e.employee_code,
    e.first_name,
    e.last_name,
    e.employment_status,

    d.department_name,
    pos.position_name,

    pp.period_code,
    pp.start_date,
    pp.end_date,
    pp.payment_date,

    p.gross_salary,
    p.bonuses,
    p.deductions,
    p.net_salary

FROM employees e

JOIN departments d
    ON d.department_id = e.department_id

JOIN positions pos
    ON pos.position_id = e.position_id

JOIN payroll p
    ON p.employee_id = e.employee_id

JOIN payroll_periods pp
    ON pp.period_id = p.period_id;