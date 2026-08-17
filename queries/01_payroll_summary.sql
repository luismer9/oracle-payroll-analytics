/* ============================================================
   PROJECT: Oracle Payroll Analytics
   FILE: 01_payroll_summary.sql
   DESCRIPTION:
   Monthly payroll summary by payroll period.
   ============================================================ */

SELECT
    pp.period_code,
    pp.start_date,
    pp.end_date,
    pp.payment_date,

    COUNT(p.payroll_id) AS employees_paid,

    SUM(p.gross_salary) AS total_gross_salary,

    SUM(p.bonuses) AS total_bonuses,

    SUM(p.deductions) AS total_deductions,

    SUM(p.net_salary) AS total_net_salary

FROM payroll p

JOIN payroll_periods pp
    ON pp.period_id = p.period_id

GROUP BY
    pp.period_code,
    pp.start_date,
    pp.end_date,
    pp.payment_date

ORDER BY
    pp.start_date;

/* ============================================================
   MONTH-OVER-MONTH PAYROLL VARIATION
   ============================================================ */

WITH monthly_payroll AS (
    SELECT
        pp.period_code,
        pp.start_date,
        COUNT(p.payroll_id) AS employees_paid,
        SUM(p.gross_salary) AS total_gross_salary,
        SUM(p.bonuses) AS total_bonuses,
        SUM(p.deductions) AS total_deductions,
        SUM(p.net_salary) AS total_net_salary
    FROM payroll p
    JOIN payroll_periods pp
        ON pp.period_id = p.period_id
    GROUP BY
        pp.period_code,
        pp.start_date
)

SELECT
    period_code,
    employees_paid,
    total_gross_salary,
    total_bonuses,
    total_deductions,
    total_net_salary,

    LAG(total_net_salary) OVER (
        ORDER BY start_date
    ) AS previous_month_net,

    total_net_salary
    - LAG(total_net_salary) OVER (
        ORDER BY start_date
    ) AS net_variation,

    ROUND(
        (
            total_net_salary
            - LAG(total_net_salary) OVER (
                ORDER BY start_date
            )
        )
        /
        NULLIF(
            LAG(total_net_salary) OVER (
                ORDER BY start_date
            ),
            0
        )
        * 100,
        2
    ) AS variation_percentage

FROM monthly_payroll

ORDER BY start_date;

/* ============================================================
   MONTH-OVER-MONTH PAYROLL VARIATION
   ============================================================ */

WITH monthly_payroll AS (
    SELECT
        pp.period_code,
        pp.start_date,
        COUNT(p.payroll_id) AS employees_paid,
        SUM(p.gross_salary) AS total_gross_salary,
        SUM(p.bonuses) AS total_bonuses,
        SUM(p.deductions) AS total_deductions,
        SUM(p.net_salary) AS total_net_salary
    FROM payroll p
    JOIN payroll_periods pp
        ON pp.period_id = p.period_id
    GROUP BY
        pp.period_code,
        pp.start_date
)

SELECT
    period_code,
    employees_paid,
    total_gross_salary,
    total_bonuses,
    total_deductions,
    total_net_salary,

    LAG(total_net_salary) OVER (
        ORDER BY start_date
    ) AS previous_month_net,

    total_net_salary
    - LAG(total_net_salary) OVER (
        ORDER BY start_date
    ) AS net_variation,

    ROUND(
        (
            total_net_salary
            - LAG(total_net_salary) OVER (
                ORDER BY start_date
            )
        )
        /
        NULLIF(
            LAG(total_net_salary) OVER (
                ORDER BY start_date
            ),
            0
        )
        * 100,
        2
    ) AS variation_percentage

FROM monthly_payroll

ORDER BY start_date;

/* ============================================================
   PAYROLL SUMMARY BY DEPARTMENT
   ============================================================ */

SELECT
    pp.period_code,
    d.department_name,

    COUNT(DISTINCT e.employee_id) AS employees_paid,

    SUM(p.gross_salary) AS total_gross_salary,

    SUM(p.bonuses) AS total_bonuses,

    SUM(p.deductions) AS total_deductions,

    SUM(p.net_salary) AS total_net_salary

FROM payroll p

JOIN employees e
    ON e.employee_id = p.employee_id

JOIN departments d
    ON d.department_id = e.department_id

JOIN payroll_periods pp
    ON pp.period_id = p.period_id

GROUP BY
    pp.period_code,
    pp.start_date,
    d.department_name

ORDER BY
    pp.start_date,
    d.department_name;