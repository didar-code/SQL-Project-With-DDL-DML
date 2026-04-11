# 🏠 Property Selling Case Study – SQL Project

## 📌 Project Overview
This project is a comprehensive SQL-based case study for a **property selling system**. It demonstrates database design, schema creation (DDL), and sample data population (DML) for managing property listings, clients, agents, and transactions.

The project is ideal for:
- Learning SQL fundamentals
- Practicing real-world database design
- Understanding property sales domain modeling

---

## 📁 Project Structure
SQL_Final_Project/
├── Property_Selling_Case_Study_File.docx # Problem statement & requirements
├── Property_Selling_DDL_Files.sql # Table creation scripts
├── Property_Selling_DML_Files.sql # Data insertion scripts
└── README.md # Project documentation

---

## 🗃️ Database Schema (DDL)
The DDL script includes `CREATE TABLE` statements for entities such as:

- **Property** – property details (type, price, location, status)
- **Client** – buyer/seller information
- **Agent** – real estate agents
- **Transaction** – sale/purchase records
- **Appointment** – site visit scheduling

> 📄 File: `Property_Selling_DDL_Files.sql`

---

## 📊 Sample Data (DML)
The DML script inserts realistic sample records into all tables, including:

- Multiple property listings
- Client profiles (buyers & sellers)
- Assigned agents
- Completed and pending transactions

> 📄 File: `Property_Selling_DML_Files.sql`

---

## 🚀 How to Run the Project

### Prerequisites
- Any SQL database system (MySQL, PostgreSQL, SQL Server, Oracle)
- A SQL client (DBeaver, DataGrip, MySQL Workbench, pgAdmin, etc.)

### Steps
1. Open your SQL environment.
2. Run `Property_Selling_DDL_Files.sql` to create the database and tables.
3. Run `Property_Selling_DML_Files.sql` to insert sample data.
4. Start writing queries to analyze:
   - Most expensive properties
   - Agent performance
   - Pending transactions
   - Client purchase history

---

## 🔍 Example Queries You Can Try

```sql
-- List all available properties
SELECT * FROM Property WHERE status = 'Available';

-- Find total sales by each agent
SELECT agent_id, COUNT(*) as total_sales
FROM Transaction
GROUP BY agent_id;

-- Top 3 most expensive properties sold
SELECT * FROM Property
ORDER BY price DESC
LIMIT 3;
Let me know if you want me to **customize it further** (e.g., add actual table names, ER diagram notes, or specific query outputs).
