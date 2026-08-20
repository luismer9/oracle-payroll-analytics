/* ============================================================
   PROJECT: Oracle Payroll Analytics
   FILE: 06_employee_payroll_trends.sql
   DESCRIPTION:
   Employee-level payroll trends, cumulative totals,
   averages, variations and rankings.
   ============================================================ */


/* ============================================================
   1. EMPLOYEE PAYROLL HISTORY
   ============================================================ */

SELECT
    e.employee_code,
    e.first_name,
    e.last_name,
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

ORDER BY
    e.employee_code,
    pp.payment_date;

/* ============================================================
   2. CUMULATIVE NET SALARY PER EMPLOYEE
   ============================================================ */

SELECT
    e.employee_code,
    e.first_name,
    e.last_name,
    pp.period_code,
    pp.payment_date,
    p.net_salary,

    SUM(p.net_salary) OVER (
        PARTITION BY e.employee_id
        ORDER BY pp.payment_date
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND CURRENT ROW
    ) AS cumulative_net_salary

FROM payroll p

JOIN employees e
    ON e.employee_id = p.employee_id

JOIN payroll_periods pp
    ON pp.period_id = p.period_id

ORDER BY
    e.employee_code,
    pp.payment_date;

/* ============================================================
   3. EMPLOYEE AVERAGE PAYROLL
   ============================================================ */

SELECT
    e.employee_code,
    e.first_name,
    e.last_name,
    pp.period_code,
    p.net_salary,

    ROUND(
        AVG(p.net_salary) OVER (
            PARTITION BY e.employee_id
        ),
        2
    ) AS average_net_salary,

    ROUND(
        p.net_salary
        - AVG(p.net_salary) OVER (
            PARTITION BY e.employee_id
        ),
        2
    ) AS difference_from_employee_average

FROM payroll p

JOIN employees e
    ON e.employee_id = p.employee_id

JOIN payroll_periods pp
    ON pp.period_id = p.period_id

ORDER BY
    e.employee_code,
    pp.payment_date;

/* ============================================================
   4. EMPLOYEE MONTH-OVER-MONTH PAYROLL VARIATION
   ============================================================ */

WITH employee_payroll AS (
    SELECT
        e.employee_id,
        e.employee_code,
        e.first_name,
        e.last_name,
        pp.period_code,
        pp.payment_date,
        p.net_salary,

        LAG(p.net_salary) OVER (
            PARTITION BY e.employee_id
            ORDER BY pp.payment_date
        ) AS previous_net_salary

    FROM payroll p

    JOIN employees e
        ON e.employee_id = p.employee_id

    JOIN payroll_periods pp
        ON pp.period_id = p.period_id
)

SELECT
    employee_code,
    first_name,
    last_name,
    period_code,
    net_salary,
    previous_net_salary,

    net_salary - previous_net_salary AS salary_variation,

    ROUND((net_salary - previous_net_salary) / NULLIF(previous_net_salary, 0) * 100,2) AS variation_percentage

FROM employee_payroll

ORDER BY
    employee_code,
    payment_date;

/* ============================================================
   5. EMPLOYEE TOTAL PAYROLL RANKING
   ============================================================ */

WITH employee_totals AS (
    SELECT
        e.employee_id,
        e.employee_code,
        e.first_name,
        e.last_name,

        SUM(p.gross_salary) AS total_gross_salary,
        SUM(p.bonuses) AS total_bonuses,
        SUM(p.deductions) AS total_deductions,
        SUM(p.net_salary) AS total_net_salary

    FROM payroll p

    JOIN employees e
        ON e.employee_id = p.employee_id

    GROUP BY
        e.employee_id,
        e.employee_code,
        e.first_name,
        e.last_name
)

SELECT
    employee_code,
    first_name,
    last_name,
    total_gross_salary,
    total_bonuses,
    total_deductions,
    total_net_salary,

    DENSE_RANK() OVER (
        ORDER BY total_net_salary DESC
    ) AS payroll_rank

FROM employee_totals

ORDER BY payroll_rank;

/* ============================================================
   6. EMPLOYEE BONUS ANALYSIS
   ============================================================ */

SELECT
    e.employee_code,
    e.first_name,
    e.last_name,

    COUNT(
        CASE
            WHEN p.bonuses > 0 THEN 1
        END
    ) AS periods_with_bonus,

    SUM(p.bonuses) AS total_bonuses,

    ROUND(
        AVG(
            CASE
                WHEN p.bonuses > 0
                THEN p.bonuses
            END
        ),
        2
    ) AS average_bonus,

    MAX(p.bonuses) AS highest_bonus

FROM payroll p

JOIN employees e
    ON e.employee_id = p.employee_id

GROUP BY
    e.employee_code,
    e.first_name,
    e.last_name

ORDER BY
    total_bonuses DESC;

/* ============================================================
   7. HIGHEST PAID EMPLOYEE BY MONTH
   ============================================================ */

WITH monthly_employee_payroll AS (
    SELECT
        pp.period_code,
        pp.payment_date,
        e.employee_code,
        e.first_name,
        e.last_name,
        p.net_salary,

        DENSE_RANK() OVER (
            PARTITION BY pp.period_id
            ORDER BY p.net_salary DESC
        ) AS salary_rank

    FROM payroll p

    JOIN employees e
        ON e.employee_id = p.employee_id

    JOIN payroll_periods pp
        ON pp.period_id = p.period_id
)

SELECT
    period_code,
    employee_code,
    first_name,
    last_name,
    net_salary

FROM monthly_employee_payroll

WHERE salary_rank = 1

ORDER BY payment_date;