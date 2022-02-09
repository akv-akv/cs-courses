CREATE TABLE stg.hh_vacancies
    (
        id INT
        , name VARCHAR(255)
        , published_at TIMESTAMP
        , key_skills TEXT
        , description TEXT
        , schedule_name VARCHAR(255)
        , experience_name VARCHAR(255)
        , area_name VARCHAR(255)
        , employer_name VARCHAR(255)
        , url VARCHAR(500)
        , salary_to INT
        , salary_from INT
        , salary_currency VARCHAR(10)
        , salary_gross BOOLEAN
        , has_test BOOLEAN
        , type_name VARCHAR(100)
        , updated_at TIMESTAMP DEFAULT current_timestamp
    )


CREATE TABLE stg.cbr_currencies
    (
        ID  VARCHAR(20)
        , NumCode INT
        , CharCode VARCHAR(10)  
        , Nominal INT        
        , Name VARCHAR(100)
        , Value DECIMAL       
        , date DATE
    )