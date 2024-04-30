-- Initialize the database schema for HR Claims System
-- Create Roles table
CREATE TABLE IF NOT EXISTS ROLES (
    ROLEID INTEGER PRIMARY KEY AUTOINCREMENT,
    ROLENAME TEXT NOT NULL
);

-- Create Users table with expanded attributes
CREATE TABLE IF NOT EXISTS USERS (
    USERID INTEGER PRIMARY KEY AUTOINCREMENT,
    FIRSTNAME TEXT NOT NULL,
    LASTNAME TEXT NOT NULL,
    EMAIL TEXT NOT NULL UNIQUE,
    PASSWORD TEXT NOT NULL,
    PHONENUMBER TEXT,
    JOBTITLE TEXT NOT NULL,
    DEPARTMENT TEXT,
    HIREDATE TEXT,
    STATUS TEXT CHECK (STATUS IN ( 'Active', 'Inactive', 'On Leave' ) ),
    ROLEID INTEGER,
    FOREIGN KEY (ROLEID) REFERENCES ROLES(ROLEID)
);

-- Create ClaimTypes table
CREATE TABLE IF NOT EXISTS CLAIMTYPES (
    CLAIMTYPEID INTEGER PRIMARY KEY AUTOINCREMENT,
    TYPENAME TEXT NOT NULL,
    DESCRIPTION TEXT
);

-- Create Claims table
CREATE TABLE IF NOT EXISTS CLAIMS (
    CLAIMID INTEGER PRIMARY KEY AUTOINCREMENT,
    USERID INTEGER,
    CLAIMTYPEID INTEGER,
    AMOUNT REAL CHECK (AMOUNT > 0),
    SUBMISSIONDATE TEXT NOT NULL,
    STATUSID INTEGER,
    DESCRIPTION TEXT,
    URGENCY INTEGER DEFAULT 0,
    FOREIGN KEY (USERID) REFERENCES USERS(USERID),
    FOREIGN KEY (CLAIMTYPEID) REFERENCES CLAIMTYPES(CLAIMTYPEID),
    FOREIGN KEY (STATUSID) REFERENCES CLAIMSTATUS(STATUSID)
);

-- Create ClaimStatus table
CREATE TABLE IF NOT EXISTS CLAIMSTATUS (
    STATUSID INTEGER PRIMARY KEY AUTOINCREMENT,
    STATUSNAME TEXT NOT NULL
);

-- Create ClaimApprovals table
CREATE TABLE IF NOT EXISTS CLAIMAPPROVALS (
    APPROVALID INTEGER PRIMARY KEY AUTOINCREMENT,
    CLAIMID INTEGER,
    APPROVERID INTEGER,
    APPROVALDATE TEXT,
    APPROVALSTATUS TEXT CHECK (APPROVALSTATUS IN ('Approved', 'Rejected', 'Pending')),
    FOREIGN KEY (CLAIMID) REFERENCES CLAIMS(CLAIMID),
    FOREIGN KEY (APPROVERID) REFERENCES USERS(USERID)
);

-- Insert initial data into Roles
INSERT INTO ROLES (
    ROLENAME
) VALUES (
    'Employee'
),
(
    'Approver'
),
(
    'Admin'
);

-- Insert initial data into ClaimStatus
INSERT INTO CLAIMSTATUS (
    STATUSNAME
) VALUES (
    'Submitted'
),
(
    'Approved'
),
(
    'Rejected'
);

-- Insert initial data into Users
INSERT INTO USERS (
    FIRSTNAME,
    LASTNAME,
    EMAIL,
    PASSWORD,
    PHONENUMBER,
    JOBTITLE,
    DEPARTMENT,
    HIREDATE,
    STATUS,
    ROLEID
) VALUES (
    'John',
    'Doe',
    'john.doe@example.com',
    '$2a$12$CgF3nzfhXEKUt2Fkl9ysj.ug0qwRDqawDfbunlxBGCdLhTgJwfe6y',
    '555-0123',
    'Software Developer',
    'Engineering',
    '2020-01-10',
    'Active',
    ( SELECT ROLEID FROM ROLES WHERE ROLENAME = 'Employee' )
),
(
    'Jane',
    'Smith',
    'jane.smith@example.com',
    '$2a$12$CgF3nzfhXEKUt2Fkl9ysj.ug0qwRDqawDfbunlxBGCdLhTgJwfe6y',
    '555-0456',
    'Project Manager',
    'Project Management',
    '2019-03-15',
    'Active',
    ( SELECT ROLEID FROM ROLES WHERE ROLENAME = 'Employee' )
),
(
    'Emily',
    'Jones',
    'emily.jones@example.com',
    '$2a$12$CgF3nzfhXEKUt2Fkl9ysj.ug0qwRDqawDfbunlxBGCdLhTgJwfe6y',
    '555-0789',
    'Product Owner',
    'Product Team',
    '2018-07-23',
    'Active',
    ( SELECT ROLEID FROM ROLES WHERE ROLENAME = 'Employee' )
),
(
    'Michael',
    'Brown',
    'michael.brown@example.com',
    '$2a$12$CgF3nzfhXEKUt2Fkl9ysj.ug0qwRDqawDfbunlxBGCdLhTgJwfe6y',
    '555-0124',
    'HR Coordinator',
    'Human Resources',
    '2021-05-10',
    'Active',
    ( SELECT ROLEID FROM ROLES WHERE ROLENAME = 'Admin' )
),
(
    'Jessica',
    'Davis',
    'jessica.davis@example.com',
    '$2a$12$CgF3nzfhXEKUt2Fkl9ysj.ug0qwRDqawDfbunlxBGCdLhTgJwfe6y',
    '555-0457',
    'Data Analyst',
    'Data Science',
    '2020-11-01',
    'Active',
    ( SELECT ROLEID FROM ROLES WHERE ROLENAME = 'Employee' )
),
(
    'William',
    'Wilson',
    'william.wilson@example.com',
    '$2a$12$CgF3nzfhXEKUt2Fkl9ysj.ug0qwRDqawDfbunlxBGCdLhTgJwfe6y',
    '555-0790',
    'Systems Administrator',
    'IT Support',
    '2019-01-20',
    'Active',
    ( SELECT ROLEID FROM ROLES WHERE ROLENAME = 'Employee' )
),
(
    'Olivia',
    'Moore',
    'olivia.moore@example.com',
    '$2a$12$CgF3nzfhXEKUt2Fkl9ysj.ug0qwRDqawDfbunlxBGCdLhTgJwfe6y',
    '555-0125',
    'Chief Technology Officer',
    'Executive',
    '2017-03-15',
    'Active',
    ( SELECT ROLEID FROM ROLES WHERE ROLENAME = 'Admin' )
),
(
    'Matthew',
    'Taylor',
    'matthew.taylor@example.com',
    '$2a$12$CgF3nzfhXEKUt2Fkl9ysj.ug0qwRDqawDfbunlxBGCdLhTgJwfe6y',
    '555-0458',
    'Marketing Specialist',
    'Marketing',
    '2018-06-22',
    'On Leave',
    ( SELECT ROLEID FROM ROLES WHERE ROLENAME = 'Employee' )
),
(
    'Sophia',
    'Anderson',
    'sophia.anderson@example.com',
    '$2a$12$CgF3nzfhXEKUt2Fkl9ysj.ug0qwRDqawDfbunlxBGCdLhTgJwfe6y',
    '555-0791',
    'Customer Service Representative',
    'Customer Service',
    '2019-12-04',
    'Active',
    ( SELECT ROLEID FROM ROLES WHERE ROLENAME = 'Employee' )
),
(
    'Daniel',
    'Thomas',
    'daniel.thomas@example.com',
    '$2a$12$CgF3nzfhXEKUt2Fkl9ysj.ug0qwRDqawDfbunlxBGCdLhTgJwfe6y',
    '555-0126',
    'Financial Analyst',
    'Finance',
    '2021-08-10',
    'Active',
    ( SELECT ROLEID FROM ROLES WHERE ROLENAME = 'Employee' )
),
(
    'Linda',
    'Jackson',
    'linda.jackson@example.com',
    '$2a$12$CgF3nzfhXEKUt2Fkl9ysj.ug0qwRDqawDfbunlxBGCdLhTgJwfe6y',
    '555-0459',
    'Sales Executive',
    'Sales',
    '2019-04-18',
    'Active',
    ( SELECT ROLEID FROM ROLES WHERE ROLENAME = 'Employee' )
),
(
    'David',
    'White',
    'david.white@example.com',
    '$2a$12$CgF3nzfhXEKUt2Fkl9ysj.ug0qwRDqawDfbunlxBGCdLhTgJwfe6y',
    '555-0792',
    'Legal Advisor',
    'Legal',
    '2021-02-14',
    'Active',
    ( SELECT ROLEID FROM ROLES WHERE ROLENAME = 'Employee' )
),
(
    'Sarah',
    'Martin',
    'sarah.martin@example.com',
    '$2a$12$CgF3nzfhXEKUt2Fkl9ysj.ug0qwRDqawDfbunlxBGCdLhTgJwfe6y',
    '555-0127',
    'Recruitment Specialist',
    'Human Resources',
    '2020-05-20',
    'Active',
    ( SELECT ROLEID FROM ROLES WHERE ROLENAME = 'Employee' )
),
(
    'James',
    'Clark',
    'james.clark@example.com',
    '$2a$12$CgF3nzfhXEKUt2Fkl9ysj.ug0qwRDqawDfbunlxBGCdLhTgJwfe6y',
    '555-0460',
    'Graphic Designer',
    'Design',
    '2021-09-07',
    'Active',
    ( SELECT ROLEID FROM ROLES WHERE ROLENAME = 'Employee' )
),
(
    'Patricia',
    'Lewis',
    'patricia.lewis@example.com',
    '$2a$12$CgF3nzfhXEKUt2Fkl9ysj.ug0qwRDqawDfbunlxBGCdLhTgJwfe6y',
    '555-0793',
    'Operations Manager',
    'Operations',
    '2018-01-29',
    'Inactive',
    ( SELECT ROLEID FROM ROLES WHERE ROLENAME = 'Employee' )
),
(
    'Robert',
    'Walker',
    'robert.walker@example.com',
    '$2a$12$CgF3nzfhXEKUt2Fkl9ysj.ug0qwRDqawDfbunlxBGCdLhTgJwfe6y',
    '555-0128',
    'Quality Assurance Engineer',
    'Quality Control',
    '2020-03-11',
    'Active',
    ( SELECT ROLEID FROM ROLES WHERE ROLENAME = 'Employee' )
),
(
    'Jennifer',
    'Allen',
    'jennifer.allen@example.com',
    '$2a$12$CgF3nzfhXEKUt2Fkl9ysj.ug0qwRDqawDfbunlxBGCdLhTgJwfe6y',
    '555-0461',
    'Supply Chain Coordinator',
    'Logistics',
    '2019-08-23',
    'Active',
    ( SELECT ROLEID FROM ROLES WHERE ROLENAME = 'Employee' )
),
(
    'Joseph',
    'Young',
    'joseph.young@example.com',
    '$2a$12$CgF3nzfhXEKUt2Fkl9ysj.ug0qwRDqawDfbunlxBGCdLhTgJwfe6y',
    '555-0794',
    'Corporate Trainer',
    'Training',
    '2020-07-15',
    'Active',
    ( SELECT ROLEID FROM ROLES WHERE ROLENAME = 'Employee' )
),
(
    'Maria',
    'King',
    'maria.king@example.com',
    '$2a$12$CgF3nzfhXEKUt2Fkl9ysj.ug0qwRDqawDfbunlxBGCdLhTgJwfe6y',
    '555-0129',
    'Business Analyst',
    'Business Development',
    '2018-12-10',
    'Active',
    ( SELECT ROLEID FROM ROLES WHERE ROLENAME = 'Employee' )
),
(
    'Charles',
    'Scott',
    'charles.scott@example.com',
    '$2a$12$CgF3nzfhXEKUt2Fkl9ysj.ug0qwRDqawDfbunlxBGCdLhTgJwfe6y',
    '555-0462',
    'Research and Development Manager',
    'R&D',
    '2019-10-05',
    'Active',
    ( SELECT ROLEID FROM ROLES WHERE ROLENAME = 'Employee' )
);