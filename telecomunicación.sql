CREATE SCHEMA churn;

CREATE TABLE churn.customer_churn_raw (
    customer_id TEXT,
    gender TEXT,
    senior_citizen TEXT,
    partner TEXT,
    dependents TEXT,
    tenure TEXT,
    phone_service TEXT,
    multiple_lines TEXT,
    internet_service TEXT,
    online_security TEXT,
    online_backup TEXT,
    device_protection TEXT,
    tech_support TEXT,
    streaming_tv TEXT,
    streaming_movies TEXT,
    contract TEXT,
    paperless_billing TEXT,
    payment_method TEXT,
    monthly_charges TEXT,
    total_charges TEXT,
    churn TEXT
);

--CONTEO
SELECT *
FROM churn.customer_churn_raw;

--Verificar estructura de la tabla
SELECT column_name,
       data_type
FROM information_schema.columns
WHERE table_schema = 'churn'
  AND table_name = 'customer_churn_raw';

--duplicados
SELECT customer_id,
       COUNT(*)
FROM churn.customer_churn_raw
GROUP BY customer_id
HAVING COUNT(*) > 1;

--identificador de vacios
SELECT COUNT(*)
FROM churn.customer_churn_raw
WHERE TRIM(total_charges) = '';

--tamaño de la población
SELECT
    COUNT(*) AS total_customers
FROM churn.customer_churn_raw;

--Distribución de churn
SELECT
    churn,
    COUNT(*) AS customers,
    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (),
        2
    ) AS percentage
FROM churn.customer_churn_raw
GROUP BY churn;

--perfilado inicial de variables
SELECT
    gender,
    COUNT(*) AS customers
FROM churn.customer_churn_raw
GROUP BY gender;

--tipo de contrato
SELECT
    contract,
    COUNT(*) AS customers
FROM churn.customer_churn_raw
GROUP BY contract
ORDER BY customers DESC;

--tipo de internet
SELECT
    internet_service,
    COUNT(*) AS customers
FROM churn.customer_churn_raw
GROUP BY internet_service
ORDER BY customers DESC;

--consulta 1
SELECT COUNT(*)
FROM churn.customer_churn_raw
WHERE TRIM(total_charges) = '';

--consulta 2
SELECT customer_id,
       COUNT(*)
FROM churn.customer_churn_raw
GROUP BY customer_id
HAVING COUNT(*) > 1;

--consulta 3 
SELECT
    churn,
    COUNT(*) AS customers,
    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (),
        2
    ) AS percentage
FROM churn.customer_churn_raw
GROUP BY churn;

--registros vacios
SELECT
    customer_id,
    tenure,
    monthly_charges,
    total_charges,
    churn
FROM churn.customer_churn_raw
WHERE TRIM(total_charges) = '';

--consulta adicional
SELECT
    MIN(tenure::INT) AS min_tenure,
    MAX(tenure::INT) AS max_tenure,
    ROUND(AVG(tenure::INT),2) AS avg_tenure
FROM churn.customer_churn_raw;

--consulta adicional2
SELECT
    MIN(monthly_charges::NUMERIC) AS min_monthly,
    MAX(monthly_charges::NUMERIC) AS max_monthly,
    ROUND(AVG(monthly_charges::NUMERIC),2) AS avg_monthly
FROM churn.customer_churn_raw;

--TABLA LIMPIA
CREATE TABLE churn.customer_churn (

    customer_id VARCHAR(20) PRIMARY KEY,

    gender VARCHAR(10),

    senior_citizen BOOLEAN,

    partner BOOLEAN,

    dependents BOOLEAN,

    tenure INTEGER,

    phone_service BOOLEAN,

    multiple_lines VARCHAR(25),

    internet_service VARCHAR(20),

    online_security VARCHAR(25),

    online_backup VARCHAR(25),

    device_protection VARCHAR(25),

    tech_support VARCHAR(25),

    streaming_tv VARCHAR(25),

    streaming_movies VARCHAR(25),

    contract VARCHAR(30),

    paperless_billing BOOLEAN,

    payment_method VARCHAR(50),

    monthly_charges NUMERIC(10,2),

    total_charges NUMERIC(12,2),

    churn BOOLEAN
);

--datos transformados 
INSERT INTO churn.customer_churn
SELECT

    customer_id,

    gender,

    CASE
        WHEN senior_citizen = '1' THEN TRUE
        ELSE FALSE
    END,

    CASE
        WHEN partner = 'Yes' THEN TRUE
        ELSE FALSE
    END,

    CASE
        WHEN dependents = 'Yes' THEN TRUE
        ELSE FALSE
    END,

    tenure::INTEGER,

    CASE
        WHEN phone_service = 'Yes' THEN TRUE
        ELSE FALSE
    END,

    multiple_lines,

    internet_service,

    online_security,

    online_backup,

    device_protection,

    tech_support,

    streaming_tv,

    streaming_movies,

    contract,

    CASE
        WHEN paperless_billing = 'Yes' THEN TRUE
        ELSE FALSE
    END,

    payment_method,

    monthly_charges::NUMERIC,

    CASE
        WHEN TRIM(total_charges) = '' THEN 0
        ELSE total_charges::NUMERIC
    END,

    CASE
        WHEN churn = 'Yes' THEN TRUE
        ELSE FALSE
    END

FROM churn.customer_churn_raw;

--cuantos valores tenemos
SELECT COUNT(*)
FROM churn.customer_churn;

--validación de la tabla
SELECT *
FROM churn.customer_churn
LIMIT 10;

--KP1 1	churn rate 
SELECT
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churn = TRUE THEN 1 ELSE 0 END) AS lost_customers,
    ROUND(
        SUM(CASE WHEN churn = TRUE THEN 1 ELSE 0 END) * 100.0
        / COUNT(*),
        2
    ) AS churn_rate
FROM churn.customer_churn;

--kpi 2 retention rate
SELECT
    ROUND(
        SUM(CASE WHEN churn = FALSE THEN 1 ELSE 0 END) * 100.0
        / COUNT(*),
        2
    ) AS retention_rate
FROM churn.customer_churn;

--churn por genero
SELECT
    gender,
    COUNT(*) AS customers,
    SUM(CASE WHEN churn THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        SUM(CASE WHEN churn THEN 1 ELSE 0 END) * 100.0
        / COUNT(*),
        2
    ) AS churn_rate
FROM churn.customer_churn
GROUP BY gender;

--churn por adulto mayor:
SELECT
    senior_citizen,
    COUNT(*) AS customers,
    SUM(CASE WHEN churn THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        SUM(CASE WHEN churn THEN 1 ELSE 0 END) * 100.0
        / COUNT(*),
        2
    ) AS churn_rate
FROM churn.customer_churn
GROUP BY senior_citizen;

--churn por tipo de contrato
SELECT
    contract,
    COUNT(*) AS customers,
    SUM(CASE WHEN churn THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        SUM(CASE WHEN churn THEN 1 ELSE 0 END) * 100.0
        / COUNT(*),
        2
    ) AS churn_rate
FROM churn.customer_churn
GROUP BY contract
ORDER BY churn_rate DESC;

---churn por servicio de internet
SELECT
    internet_service,
    COUNT(*) AS customers,
    SUM(CASE WHEN churn THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        SUM(CASE WHEN churn THEN 1 ELSE 0 END) * 100.0
        / COUNT(*),
        2
    ) AS churn_rate
FROM churn.customer_churn
GROUP BY internet_service
ORDER BY churn_rate DESC;

--revenue at risk
SELECT
    ROUND(
        SUM(monthly_charges),
        2
    ) AS revenue_at_risk
FROM churn.customer_churn
WHERE churn = TRUE;

--antiguedad y churn
SELECT
    churn,
    ROUND(AVG(tenure),2) AS avg_tenure
FROM churn.customer_churn
GROUP BY churn;

--churn por metodo de pago
SELECT
    payment_method,
    COUNT(*) AS customers,
    SUM(CASE WHEN churn THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        SUM(CASE WHEN churn THEN 1 ELSE 0 END) * 100.0
        / COUNT(*),
        2
    ) AS churn_rate
FROM churn.customer_churn
GROUP BY payment_method
ORDER BY churn_rate DESC;

--churn por online security

SELECT
    online_security,
    COUNT(*) AS customers,
    SUM(CASE WHEN churn THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        SUM(CASE WHEN churn THEN 1 ELSE 0 END) * 100.0
        / COUNT(*),
        2
    ) AS churn_rate
FROM churn.customer_churn
GROUP BY online_security
ORDER BY churn_rate DESC;

--churn por tech support 
SELECT
    tech_support,
    COUNT(*) AS customers,
    SUM(CASE WHEN churn THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        SUM(CASE WHEN churn THEN 1 ELSE 0 END) * 100.0
        / COUNT(*),
        2
    ) AS churn_rate
FROM churn.customer_churn
GROUP BY tech_support
ORDER BY churn_rate DESC;

--churn por online backup
SELECT
    online_backup,
    COUNT(*) AS customers,
    SUM(CASE WHEN churn THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        SUM(CASE WHEN churn THEN 1 ELSE 0 END) * 100.0
        / COUNT(*),
        2
    ) AS churn_rate
FROM churn.customer_churn
GROUP BY online_backup
ORDER BY churn_rate DESC;

-- Churn por Device Protection
SELECT
    device_protection,
    COUNT(*) AS customers,
    SUM(CASE WHEN churn THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        SUM(CASE WHEN churn THEN 1 ELSE 0 END) * 100.0
        / COUNT(*),
        2
    ) AS churn_rate
FROM churn.customer_churn
GROUP BY device_protection
ORDER BY churn_rate DESC;

--Segmentación por Antigüedad
SELECT
    CASE
        WHEN tenure <= 12 THEN 'New Customers'
        WHEN tenure <= 24 THEN 'Developing Customers'
        WHEN tenure <= 48 THEN 'Established Customers'
        ELSE 'Loyal Customers'
    END AS tenure_segment,

    COUNT(*) AS customers,

    SUM(CASE WHEN churn THEN 1 ELSE 0 END) AS churned_customers,

    ROUND(
        SUM(CASE WHEN churn THEN 1 ELSE 0 END) * 100.0
        / COUNT(*),
        2
    ) AS churn_rate

FROM churn.customer_churn

GROUP BY 1

ORDER BY churn_rate DESC;

--revenue por estado de cliente:
SELECT
    churn,

    COUNT(*) AS customers,

    ROUND(SUM(monthly_charges),2) AS total_monthly_revenue,

    ROUND(AVG(monthly_charges),2) AS avg_monthly_revenue

FROM churn.customer_churn

GROUP BY churn;


---------------------------------VISTA ANALITICA
CREATE OR REPLACE VIEW churn.vw_customer_churn_analysis AS

SELECT

    customer_id,
    gender,
    senior_citizen,
    partner,
    dependents,
    tenure,
    phone_service,
    multiple_lines,
    internet_service,
    online_security,
    online_backup,
    device_protection,
    tech_support,
    streaming_tv,
    streaming_movies,
    contract,
    paperless_billing,
    payment_method,
    monthly_charges,
    total_charges,
    churn,

    ---------------------------------------------------
    -- TENURE SEGMENT
    ---------------------------------------------------

    CASE
        WHEN tenure <= 12 THEN 'New Customers'
        WHEN tenure <= 24 THEN 'Developing Customers'
        WHEN tenure <= 48 THEN 'Established Customers'
        ELSE 'Loyal Customers'
    END AS tenure_segment,

    ---------------------------------------------------
    -- REVENUE BAND
    ---------------------------------------------------

    CASE
        WHEN monthly_charges < 40 THEN 'Low Revenue'
        WHEN monthly_charges < 80 THEN 'Medium Revenue'
        ELSE 'High Revenue'
    END AS revenue_band,

    ---------------------------------------------------
    -- CUSTOMER RISK SCORE
    ---------------------------------------------------

    (
        CASE
            WHEN contract = 'Month-to-month' THEN 3
            WHEN contract = 'One year' THEN 1
            ELSE 0
        END

        +

        CASE
            WHEN tenure <= 12 THEN 3
            WHEN tenure <= 24 THEN 2
            WHEN tenure <= 48 THEN 1
            ELSE 0
        END

        +

        CASE
            WHEN internet_service = 'Fiber optic' THEN 2
            WHEN internet_service = 'DSL' THEN 1
            ELSE 0
        END

        +

        CASE
            WHEN payment_method = 'Electronic check' THEN 2
            ELSE 0
        END

        +

        CASE
            WHEN online_security = 'No' THEN 2
            ELSE 0
        END

        +

        CASE
            WHEN tech_support = 'No' THEN 2
            ELSE 0
        END

        +

        CASE
            WHEN senior_citizen = TRUE THEN 1
            ELSE 0
        END

    ) AS risk_score

FROM churn.customer_churn;

--agregación de segmetación de riesgo
CREATE OR REPLACE VIEW churn.vw_customer_churn_analysis AS

WITH risk_base AS (

SELECT

    customer_id,
    gender,
    senior_citizen,
    partner,
    dependents,
    tenure,
    phone_service,
    multiple_lines,
    internet_service,
    online_security,
    online_backup,
    device_protection,
    tech_support,
    streaming_tv,
    streaming_movies,
    contract,
    paperless_billing,
    payment_method,
    monthly_charges,
    total_charges,
    churn,

    CASE
        WHEN tenure <= 12 THEN 'New Customers'
        WHEN tenure <= 24 THEN 'Developing Customers'
        WHEN tenure <= 48 THEN 'Established Customers'
        ELSE 'Loyal Customers'
    END AS tenure_segment,

    CASE
        WHEN monthly_charges < 40 THEN 'Low Revenue'
        WHEN monthly_charges < 80 THEN 'Medium Revenue'
        ELSE 'High Revenue'
    END AS revenue_band,

    (
        CASE
            WHEN contract = 'Month-to-month' THEN 3
            WHEN contract = 'One year' THEN 1
            ELSE 0
        END

        +

        CASE
            WHEN tenure <= 12 THEN 3
            WHEN tenure <= 24 THEN 2
            WHEN tenure <= 48 THEN 1
            ELSE 0
        END

        +

        CASE
            WHEN internet_service = 'Fiber optic' THEN 2
            WHEN internet_service = 'DSL' THEN 1
            ELSE 0
        END

        +

        CASE
            WHEN payment_method = 'Electronic check' THEN 2
            ELSE 0
        END

        +

        CASE
            WHEN online_security = 'No' THEN 2
            ELSE 0
        END

        +

        CASE
            WHEN tech_support = 'No' THEN 2
            ELSE 0
        END

        +

        CASE
            WHEN senior_citizen THEN 1
            ELSE 0
        END

    ) AS risk_score

FROM churn.customer_churn

)

SELECT *,

    CASE
        WHEN risk_score <= 3 THEN 'Low Risk'
        WHEN risk_score <= 6 THEN 'Moderate Risk'
        WHEN risk_score <= 10 THEN 'High Risk'
        ELSE 'Critical Risk'
    END AS risk_segment

FROM risk_base;

-- validar la vista 
SELECT *
FROM churn.vw_customer_churn_analysis
LIMIT 10;

--validación del negocio
SELECT
    risk_segment,
    COUNT(*) AS customers
FROM churn.vw_customer_churn_analysis
GROUP BY risk_segment
ORDER BY customers DESC;

--
SELECT
    risk_segment,

    COUNT(*) AS customers,

    SUM(
        CASE WHEN churn
             THEN 1
             ELSE 0
        END
    ) AS churned_customers,

    ROUND(
        SUM(
            CASE WHEN churn
                 THEN 1
                 ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS churn_rate

FROM churn.vw_customer_churn_analysis

GROUP BY risk_segment

ORDER BY churn_rate DESC;

--analisis a
SELECT
    risk_segment,

    COUNT(*) AS customers,

    ROUND(SUM(monthly_charges),2) AS monthly_revenue,

    ROUND(
        SUM(
            CASE WHEN churn
                 THEN monthly_charges
                 ELSE 0
            END
        ),
        2
    ) AS revenue_at_risk

FROM churn.vw_customer_churn_analysis

GROUP BY risk_segment

ORDER BY revenue_at_risk DESC;

--contrato dentro de cada segmento
SELECT
    risk_segment,
    contract,
    COUNT(*) AS customers

FROM churn.vw_customer_churn_analysis

GROUP BY risk_segment, contract

ORDER BY risk_segment, customers DESC;