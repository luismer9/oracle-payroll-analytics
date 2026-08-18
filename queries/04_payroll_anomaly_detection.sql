/* ============================================================
   PROJECT: Oracle Payroll Analytics
   FILE: 04_payroll_anomaly_detection.sql
   DESCRIPTION:
   Detects payroll inconsistencies and suspicious records.
   ============================================================ */


/* ============================================================
   1. INCORRECT NET SALARY CALCULATION
   ============================================================ */

SELECT
    p.payroll_id,
    e.employee_code,
    e.first_name,
    e.last_name,
    pp.period_code,

    p.gross_salary,
    p.bonuses,
    p.deductions,
    p.net_salary,

    p.gross_salary
        + p.bonuses
        - p.deductions
        AS expected_net_salary,

    p.net_salary
        - (
            p.gross_salary
            + p.bonuses
            - p.deductions
        ) AS difference

FROM payroll p

JOIN employees e
    ON e.employee_id = p.employee_id

JOIN payroll_periods pp
    ON pp.period_id = p.period_id

WHERE p.net_salary <>
      (
          p.gross_salary
          + p.bonuses
          - p.deductions
      )

ORDER BY
    pp.payment_date,
    e.employee_code;

/* ============================================================
   2. PAYMENTS AFTER TERMINATION
   ============================================================ */

SELECT
    e.employee_code,
    e.first_name,
    e.last_name,
    e.termination_date,
    pp.period_code,
    pp.payment_date,
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
   3. DUPLICATE EMPLOYEE PAYROLL PERIODS
   ============================================================ */

SELECT
    employee_id,
    period_id,
    COUNT(*) AS duplicate_count

FROM payroll

GROUP BY
    employee_id,
    period_id

HAVING COUNT(*) > 1

ORDER BY
    employee_id,
    period_id;

/* ============================================================
   4. NEGATIVE OR INVALID PAYROLL VALUES
   ============================================================ */

SELECT
    p.payroll_id,
    e.employee_code,
    pp.period_code,
    p.gross_salary,
    p.bonuses,
    p.deductions,
    p.net_salary

FROM payroll p

JOIN employees e
    ON e.employee_id = p.employee_id

JOIN payroll_periods pp
    ON pp.period_id = p.period_id

WHERE p.gross_salary < 0
   OR p.bonuses < 0
   OR p.deductions < 0
   OR p.net_salary < 0

ORDER BY p.payroll_id;

/* ============================================================
   5. LARGE SALARY INCREASES
   ============================================================ */

SELECT
    e.employee_code,
    e.first_name,
    e.last_name,
    sh.effective_date,
    sh.previous_salary,
    sh.new_salary,

    sh.new_salary - sh.previous_salary AS salary_difference,

    ROUND((sh.new_salary - sh.previous_salary) / NULLIF(sh.previous_salary, 0) * 100,2) AS increase_percentage, 
    
    sh.change_reason

FROM salary_history sh

JOIN employees e
    ON e.employee_id = sh.employee_id

WHERE sh.previous_salary IS NOT NULL

AND ((sh.new_salary - sh.previous_salary) / NULLIF(sh.previous_salary, 0)) > 0.10

ORDER BY increase_percentage DESC;

/* ============================================================
   6. HIGH DEDUCTION RATIO
   ============================================================ */

SELECT
    e.employee_code,
    e.first_name,
    e.last_name,
    pp.period_code,

    p.gross_salary,
    p.deductions,

    ROUND(p.deductions / NULLIF(p.gross_salary, 0) * 100,2) AS deduction_percentage

FROM payroll p

JOIN employees e
    ON e.employee_id = p.employee_id

JOIN payroll_periods pp
    ON pp.period_id = p.period_id

WHERE
    p.deductions / NULLIF(p.gross_salary, 0)> 0.20

ORDER BY
    deduction_percentage DESC;

/* ============================================================
   7. CONSOLIDATED PAYROLL AUDIT
   ============================================================ */

WITH payroll_audit AS (
    SELECT
        p.payroll_id,
        e.employee_code,
        pp.period_code,

        CASE
            WHEN p.net_salary <>
                 (
                     p.gross_salary
                     + p.bonuses
                     - p.deductions
                 )
            THEN 'NET SALARY MISMATCH'

            WHEN e.termination_date IS NOT NULL
                 AND pp.payment_date > e.termination_date
            THEN 'PAYMENT AFTER TERMINATION'

            WHEN p.deductions
                 / NULLIF(p.gross_salary, 0) > 0.20
            THEN 'HIGH DEDUCTION RATIO'

            ELSE 'OK'
        END AS audit_status

    FROM payroll p

    INNER JOIN employees e
        ON e.employee_id = p.employee_id

    INNER JOIN payroll_periods pp
        ON pp.period_id = p.period_id
)

SELECT
    audit_status,
    COUNT(*) AS records
FROM payroll_audit
GROUP BY audit_status
ORDER BY records DESC;