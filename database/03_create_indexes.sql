/* ============================================================
   PROJECT: Oracle Payroll Analytics
   FILE: 03_create_indexes.sql
   DESCRIPTION:
   Creates indexes to improve common payroll reporting
   and analytical query performance.
   ============================================================ */


/* ============================================================
   1. EMPLOYEES
   ============================================================ */

CREATE INDEX idx_employees_department
    ON employees (department_id);

CREATE INDEX idx_employees_position
    ON employees (position_id);

CREATE INDEX idx_employees_status
    ON employees (employment_status);

CREATE INDEX idx_employees_termination_date
    ON employees (termination_date);


/* ============================================================
   2. PAYROLL
   ============================================================ */

CREATE INDEX idx_payroll_employee
    ON payroll (employee_id);

CREATE INDEX idx_payroll_period
    ON payroll (period_id);


/* ============================================================
   3. PAYROLL PERIODS
   ============================================================ */

CREATE INDEX idx_payroll_period_payment_date
    ON payroll_periods (payment_date);


/* ============================================================
   4. SALARY HISTORY
   ============================================================ */

CREATE INDEX idx_salary_history_employee_date
    ON salary_history (
        employee_id,
        effective_date
    );