/* ============================================================
   PROJECT: Oracle Payroll Analytics
   FILE: 05_department_cost_analysis.sql
   DESCRIPTION:
   Department payroll cost, ranking and monthly trend analysis.
   ============================================================ */


/* ============================================================
   1. TOTAL PAYROLL COST BY DEPARTMENT
   ============================================================ */

SELECT
    d.department_name,

    COUNT(DISTINCT e.employee_id) AS employees,

    SUM(p.gross_salary) AS total_gross_salary,

    SUM(p.bonuses) AS total_bonuses,

    SUM(p.deductions) AS total_deductions,

    SUM(p.net_salary) AS total_net_salary

FROM payroll p

JOIN employees e
    ON e.employee_id = p.employee_id

JOIN departments d
    ON d.department_id = e.department_id

GROUP BY
    d.department_name

ORDER BY
    total_net_salary DESC;

/* ============================================================
   2. DEPARTMENT SHARE OF TOTAL PAYROLL
   ============================================================ */

WITH department_costs AS (
    SELECT
        d.department_name,
        SUM(p.net_salary) AS department_net_salary
    FROM payroll p

    JOIN employees e
        ON e.employee_id = p.employee_id

    JOIN departments d
        ON d.department_id = e.department_id

    GROUP BY
        d.department_name
)

SELECT
    department_name,
    department_net_salary,

    SUM(department_net_salary) OVER () AS company_total_net_salary,

    ROUND(department_net_salary / NULLIF( SUM(department_net_salary) OVER (),0) * 100,2) AS payroll_share_percentage

FROM department_costs

ORDER BY
    payroll_share_percentage DESC;

/* ============================================================
   3. DEPARTMENT PAYROLL RANKING
   ============================================================ */

WITH department_costs AS (
    SELECT
        d.department_name,
        SUM(p.net_salary) AS total_net_salary
    FROM payroll p

    JOIN employees e
        ON e.employee_id = p.employee_id

    JOIN departments d
        ON d.department_id = e.department_id

    GROUP BY
        d.department_name
)

SELECT
    department_name,
    total_net_salary,

    RANK() OVER (
        ORDER BY total_net_salary DESC
    ) AS payroll_cost_rank

FROM department_costs

ORDER BY payroll_cost_rank;

/* ============================================================
   4. MONTHLY DEPARTMENT COST TREND
   ============================================================ */

SELECT
    pp.period_code,
    pp.start_date,
    d.department_name,

    COUNT(DISTINCT e.employee_id)
        AS employees_paid,

    SUM(p.net_salary)
        AS monthly_net_salary

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

/* ============================================================
   5. MONTH-OVER-MONTH DEPARTMENT COST VARIATION
   ============================================================ */

WITH monthly_department_cost AS (
    SELECT
        pp.period_code,
        pp.start_date,
        d.department_name,
        SUM(p.net_salary) AS monthly_net_salary

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
),

cost_variation AS (
    SELECT
        period_code,
        start_date,
        department_name,
        monthly_net_salary,

        LAG(monthly_net_salary) OVER (
            PARTITION BY department_name
            ORDER BY start_date
        ) AS previous_month_cost

    FROM monthly_department_cost
)

SELECT
    period_code,
    department_name,
    monthly_net_salary,
    previous_month_cost,

    monthly_net_salary - previous_month_cost AS cost_variation,

    ROUND((monthly_net_salary - previous_month_cost) / NULLIF(previous_month_cost, 0) * 100,2) AS variation_percentage

FROM cost_variation

ORDER BY
    department_name,
    start_date;

/* ============================================================
   6. MOST EXPENSIVE DEPARTMENT BY MONTH
   ============================================================ */

WITH monthly_department_cost AS (
    SELECT
        pp.period_code,
        pp.start_date,
        d.department_name,
        SUM(p.net_salary) AS monthly_net_salary

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
),

ranked_departments AS (
    SELECT
        period_code,
        start_date,
        department_name,
        monthly_net_salary,

        RANK() OVER (
            PARTITION BY period_code
            ORDER BY monthly_net_salary DESC
        ) AS cost_rank

    FROM monthly_department_cost
)

SELECT
    period_code,
    department_name,
    monthly_net_salary

FROM ranked_departments

WHERE cost_rank = 1

ORDER BY start_date;