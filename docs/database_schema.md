# Database Schema

The Oracle Payroll Analytics project uses six main relational tables.

## Departments

Stores organizational departments.

Primary key:

- `department_id`

## Positions

Stores job positions and reference salaries.

Primary key:

- `position_id`

## Employees

Stores employee master data.

Foreign keys:

- `department_id` → `departments`
- `position_id` → `positions`

## Payroll Periods

Stores payroll processing periods and payment dates.

Primary key:

- `period_id`

## Payroll

Stores payroll transactions for each employee and period.

Foreign keys:

- `employee_id` → `employees`
- `period_id` → `payroll_periods`

A unique constraint prevents duplicate payroll records for the same employee and period.

## Salary History

Stores historical salary adjustments.

Foreign key:

- `employee_id` → `employees`

## Relationships

```text
DEPARTMENTS
     │
     └── EMPLOYEES ─── POSITIONS
              │
              ├── SALARY_HISTORY
              │
              └── PAYROLL ─── PAYROLL_PERIODS
```