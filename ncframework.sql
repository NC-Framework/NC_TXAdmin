-- Characters Table
CREATE TABLE characters (
    id INT AUTO_INCREMENT PRIMARY KEY,
    citizen_id VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender ENUM('male', 'female') NOT NULL,
    job_id INT,
    job_grade INT,
    gang_id INT,
    gang_rank INT,
    cash INT DEFAULT 0,
    bank INT DEFAULT 0,
    inventory JSON DEFAULT '{}',
    position VARCHAR(255) DEFAULT '{"x":0, "y":0, "z":0}',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Jobs Table
CREATE TABLE jobs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    label VARCHAR(50) NOT NULL,
    grades JSON NOT NULL DEFAULT '[]' -- Storing grades as JSON
);

-- Gangs Table
CREATE TABLE gangs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    label VARCHAR(50) NOT NULL,
    ranks JSON NOT NULL DEFAULT '[]' -- Storing ranks as JSON
);

-- Inventories Table
CREATE TABLE inventories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    owner_id VARCHAR(50) NOT NULL,
    owner_type ENUM('character', 'job', 'gang') NOT NULL,
    items JSON DEFAULT '{}'
);

-- Stashes Table
CREATE TABLE stashes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    owner_id VARCHAR(50) NOT NULL,
    owner_type ENUM('character', 'job', 'gang') NOT NULL,
    label VARCHAR(50) NOT NULL,
    items JSON DEFAULT '{}'
);

-- Banking System Tables
-- Accounts Table
CREATE TABLE accounts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    account_number VARCHAR(20) NOT NULL UNIQUE,
    account_type ENUM('personal', 'business', 'gang', 'job', 'society') NOT NULL,
    balance INT DEFAULT 0,
    pin VARCHAR(4) DEFAULT NULL,
    owner_id VARCHAR(50) NOT NULL,
    owner_type ENUM('character', 'job', 'gang', 'society') NOT NULL
);

-- Transactions Table
CREATE TABLE transactions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    account_id INT NOT NULL,
    amount INT NOT NULL,
    transaction_type ENUM('deposit', 'withdrawal', 'transfer') NOT NULL,
    description VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (account_id) REFERENCES accounts(id)
);

-- Shared Accounts Table
CREATE TABLE shared_accounts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    account_id INT NOT NULL,
    shared_with_id VARCHAR(50) NOT NULL,
    shared_with_type ENUM('character', 'job', 'gang', 'society') NOT NULL,
    FOREIGN KEY (account_id) REFERENCES accounts(id)
);

-- Ensure Foreign Key Constraints
ALTER TABLE characters
ADD FOREIGN KEY (job_id) REFERENCES jobs(id),
ADD FOREIGN KEY (gang_id) REFERENCES gangs(id);

-- Indexes for Performance
CREATE INDEX idx_character_citizen_id ON characters(citizen_id);
CREATE INDEX idx_account_number ON accounts(account_number);
CREATE INDEX idx_inventory_owner ON inventories(owner_id, owner_type);
CREATE INDEX idx_stash_owner ON stashes(owner_id, owner_type);

-- Sample Data
INSERT INTO jobs (name, label, grades) VALUES 
('police', 'Police', '[{"grade":0,"label":"Recruit","salary":500},{"grade":1,"label":"Officer","salary":1000},{"grade":2,"label":"Sergeant","salary":1500}]'), 
('ambulance', 'EMS', '[{"grade":0,"label":"Trainee","salary":400},{"grade":1,"label":"Paramedic","salary":800},{"grade":2,"label":"Chief","salary":1200}]'),
('mechanic', 'Mechanic', '[{"grade":0,"label":"Junior Mechanic","salary":300},{"grade":1,"label":"Mechanic","salary":600},{"grade":2,"label":"Senior Mechanic","salary":900}]');

INSERT INTO gangs (name, label, ranks) VALUES 
('ballas', 'Ballas', '[{"rank":0,"label":"Thug"},{"rank":1,"label":"Hustler"},{"rank":2,"label":"Boss"}]'),
('vagos', 'Vagos', '[{"rank":0,"label":"Punk"},{"rank":1,"label":"Soldier"},{"rank":2,"label":"Leader"}]'),
('families', 'Families', '[{"rank":0,"label":"Associate"},{"rank":1,"label":"Capo"},{"rank":2,"label":"Kingpin"}]');