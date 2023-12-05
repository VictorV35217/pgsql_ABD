drop schema if exists hotel_california cascade;
create schema hotel_california;
set search_path to hotel_california;

/* Database creation */

create table room_categories (
    id serial primary key,
    name varchar(255) not null,
    description text not null,
	price decimal(10, 2) not null,
	capacity int not null
);

create table rooms (
    id serial primary key,
    number int not null,
    category_id int references room_categories(id) not null,
    status varchar (255) not null -- occupied / available / in maintenance
);

create table guests (
    id serial primary key,
    first_name varchar(255) not null,
    middle_name varchar(255),
    last_name varchar(255) not null,
    date_of_birth date not null,
    address varchar(255),
    sex char(1) not null,
    nationality varchar(255) not null,
    phone_number varchar(50) not null,
    house_number varchar(50),
    email varchar(255) not null,
    rfc varchar(255),
    place_of_origin varchar(255),
	registration_method varchar(255)
);

create table companions (
    id serial primary key,
    guest_id int references guests(id) not null,
    first_name varchar(255) not null,
    middle_name varchar(255),
    last_name varchar(255) not null,
	relationship_to_guest varchar(255) not null,
    date_of_birth date not null,
    email varchar(255) not null
);

create table packages (
    id serial primary key,
    name varchar(255) not null,
    start_date date not null,
    end_date date not null,
    room_category int references room_categories(id) not null,
    description text not null,
    discount int not null
);

create table departments (
    id serial primary key,
    name varchar(255),
    rating int,
    description text not null
);

create table agents (
    id serial primary key,
    first_name varchar(255) not null,
    last_name varchar(255) not null,
    department int references departments(id) not null,
	role varchar (255) not null
);

create table reservations (
    id serial primary key,
    room_id int references rooms(id) not null,
    agent_id int references agents(id) not null,
	room_category int references room_categories(id) not null,
    guest_id int references guests(id) not null,
    method varchar(255) not null, -- internet / phone / counter
    package int references packages(id),
    status varchar(255) not null, -- pending / completed / cancelled / in progress / expired
    check_in date not null,
    check_out date,
    date date not null,
    hour time not null,
	duration int not null,
    subtotal decimal(10, 2) not null
);

create table services (
    id serial primary key,
    type varchar(255) not null, -- internal / external
    name varchar(255) not null,
    department int references departments(id) not null,
    price decimal(10, 2) not null
);

create table consumptions (
    id serial primary key,
    reservation_id int references reservations(id) not null,
    service_id int references services(id) not null,
    department int references departments(id) not null,
    date date not null,
    hour time not null,
    subtotal decimal(10, 2) not null
);

create table final_bills (
    bill_id serial primary key,
    reservation_id int references reservations(id) not null ,
    total_room_charge decimal(10, 2) not null,
    total_services_charge decimal(10, 2) not null,
    total_package_charge decimal(10, 2) not null,
    total_amount decimal(10, 2) not null,
    issued_date date not null,
    status varchar(255) check (status IN ('pending', 'paid'))
);

create table audits (
    id serial primary key,
    agent_id int references agents(id) not null,
    guest_id int references guests(id) not null,
    check_in_date date not null,
    check_out_date date not null,
    bonus int not null
);

create table room_services (
	id serial primary key,
    room_id int references room_categories(id),
    service_id int references services(id),
	price decimal (10, 2) not null
);

create table package_suggestions (
	suggestion_id serial primary key,
    reservation_id int references reservations(id) not null,
    package_id int references packages(id) not null,
    regular_pricing decimal(10, 2) not null,
    package_pricing decimal(10, 2) not null,
    savings decimal(10, 2) not null
);

create table package_mapping (
    package_id int references packages(id) not null,
    room_service_id int references room_services(id) not null
);

create table feedback (
    id serial primary key,
    reservation_id int references reservations(id) not null,
    department int references departments(id) not null,
    description text not null,
    date date not null,
    rating int not null,
	issue_type varchar(255) not null
);

create table maintenance_log (
    id serial primary key,
    room_id int references rooms(id) not null,
    department_id int references departments(id) not null,
    description TEXT not null,
    request_date date not null,
    completion_date date,
    status varchar(255) not null check (status in ('pending', 'in progress', 'completed'))
);


/* Data insertion */

insert into room_categories (name, description, price, capacity)
values
    ('Standard', 'Basic room with essential amenities, suitable for solo travelers or couples', 100.00, 2),
    ('Deluxe', 'Spacious room with additional amenities like a minibar and a comfortable seating area', 400.00, 2),
    ('Suite', 'Luxurious room with separate living and sleeping areas, premium furnishings, and a work desk', 600.00, 2),
    ('Family', 'Designed for families, offering additional space and kid-friendly amenities', 250.00, 4),
    ('Executive', 'Tailored for business travelers, with a work area and high-speed internet', 600.00, 2),
    ('Presidential Suite', 'The most luxurious option with top-notch amenities, elegant decor, and expansive space', 1000.00, 4),
    ('Accessible', 'Ideal for guests with mobility issues or disabilities', 100.00, 2),
    ('Studio', ' Suitable for longer stays. Ideal for solo travelers or couples on extended stays', 150.00, 2);

insert into rooms (number, category_id, status)
values
    (101, 1, 'available'),
    (102, 1, 'available'),
    (103, 1, 'available'),
    (104, 1, 'available'),
    (105, 1, 'available'),
    (106, 1, 'available'),
    (107, 1, 'available'),
    (108, 1, 'available'),
    (109, 1, 'available'),
    (110, 1, 'available'),
    (201, 2, 'available'),
    (202, 2, 'available'),
    (203, 2, 'available'),
    (204, 2, 'available'),
    (205, 2, 'available'),
    (206, 2, 'available'),
    (207, 2, 'available'),
    (208, 2, 'available'),
    (209, 2, 'available'),
    (210, 2, 'available'),
    (301, 3, 'available'),
    (302, 3, 'available'),
    (303, 3, 'available'),
    (304, 3, 'available'),
    (305, 3, 'available'),
    (401, 4, 'available'),
    (402, 4, 'available'),
    (403, 4, 'available'),
    (404, 4, 'available'),
    (405, 4, 'available'),
    (501, 5, 'available'),
    (502, 5, 'available'),
    (503, 5, 'available'),
    (504, 5, 'available'),
    (505, 5, 'available'),
    (601, 6, 'available'),
    (602, 6, 'available'),
    (701, 7, 'available'),
    (702, 7, 'available'),
    (703, 7, 'available'),
    (801, 8, 'available'),
    (802, 8, 'available'),
    (803, 8, 'available'),
    (804, 8, 'available'),
    (805, 8, 'available'),
    (806, 8, 'available'),
    (807, 8, 'available'),
    (808, 8, 'available'),
    (809, 8, 'available'),
    (810, 8, 'available');

insert into guests (first_name, middle_name, last_name, date_of_birth, address, sex, nationality, phone_number, house_number, email, rfc, place_of_origin, registration_method)
values
    ('John', 'Paul', 'Acosta', '1966-07-05', '8207 Wagner Pike, Stevenfort, NJ 98972', 'F', 'Lesotho', '+1-128-841-4061', '175', 'brandi22@example.org', 'NUXJXZCVBU', 'Kingland', 'internet'),
    ('Monica', 'Lisa', 'Webb', '1970-01-03', '10487 Webb Way Suite 356, Port Stevenview, KS 37314', 'F', 'Venezuela', '9286497313', '860', 'matthewsimpson@example.org', 'TMBWZQYDRP', 'Lake Jenniferland', 'phone'),
    ('Debra', 'Rita', 'Owens', '2002-12-26', '0883 Carlos Lodge, Mcdonaldside, WY 99038', 'M', 'Netherlands Antilles', '001-963-059-9025', '59272', 'randallsullivan@example.net', 'MBYAXVHRNG', 'Bergerbury', 'counter'),
    ('Tanner', 'Angela', 'Brown', '1971-03-07', '29222 Smith Extensions Apt. 739, East James, AL 11205', 'F', 'Bangladesh', '+1-946-388-6144x844', '039', 'roberthamilton@example.com', 'VSUXCTHXPI', 'Jessicatown', 'phone'),
    ('Thomas', 'Jennifer', 'Mckay', '1937-01-31', '8792 Brenda Burgs, New Jason, NE 21535', 'F', 'Jamaica', '001-592-172-4572x95485', '969', 'micheal89@example.net', 'WFWCUZACYE', 'North Kim', 'phone'),
    ('Richard', 'Jeffrey', 'Thomas', '1978-04-11', '863 Taylor Path Apt. 557, Port Walterchester, MD 07614', 'F', 'United States Virgin Islands', '001-705-419-9573x166', '250', 'kathrynkline@example.com', 'UKIERXGVDE', 'Port Debra', 'internet'),
    ('Tracey', 'Brandon', 'Carroll', '1950-03-20', '6420 Ford Union Suite 033, New Whitney, OR 51054', 'M', 'Thailand', '001-187-619-5914x093', '109', 'kjones@example.com', 'ERMPOTQYXU', 'Gonzalezland', 'phone'),
    ('Wendy', 'Charles', 'Cruz', '1935-07-27', '38906 Sarah Islands, Karenmouth, MP 79557', 'M', 'Mali', '+1-578-944-2136', '174', 'regina19@example.org', 'XTFUQNSXSR', 'Michaelfurt', 'counter'),
    ('Leslie', 'Heather', 'Ramos', '1999-06-07', '44437 Moss Pass Suite 309, East Nathanton, AZ 55131', 'M', 'Luxembourg', '057-831-1884x729', '756', 'matthewmiller@example.org', 'FNLBDQVROG', 'Lopezville', 'internet'),
    ('Crystal', 'Taylor', 'Miller', '1959-12-12', '33813 Cory Lock, Lake Deannaton, ND 49586', 'M', 'Dominica', '8379879462', '630', 'tiffany09@example.com', 'XOVKYIBWWM', 'New Ericfurt', 'phone'),
    ('Christine', 'Gregory', 'Ortiz', '1975-08-13', '124 Courtney Lodge, Garzaside, MN 32462', 'F', 'Panama', '(448)762-7350', '0822', 'brennanjames@example.net', 'BXOEQQMWQP', 'Jacksonstad', 'counter'),
    ('Gregory', 'James', 'Harmon', '1995-10-02', '8893 Williams Drive, Lake Kerry, WY 55658', 'M', 'Central African Republic', '956-145-6040x681', '32097', 'ryan79@example.net', 'CSQFLXQTQB', 'North Robert', 'counter'),
    ('Kyle', 'Thomas', 'Harris', '1986-02-26', '744 Maurice Wells, Lake Christina, IN 59402', 'F', 'Venezuela', '515-804-1663x05877', '7756', 'troy66@example.org', 'ILIZIGJLBL', 'Robertburgh', 'internet'),
    ('Samantha', 'Randall', 'Johnson', '1983-11-02', 'Unit 7190 Box 1145, DPO AA 13525', 'F', 'Yemen', '(695)761-0784x104', '251', 'nicholas14@example.com', 'RJQNNAUXIP', 'Danielshire', 'phone'),
    ('Richard', 'Robert', 'Cline', '1933-03-25', '48135 Jared Stream, Williamburgh, VT 96999', 'F', 'Reunion', '363.031.9087x1598', '2906', 'jamescampos@example.com', 'QLJZZIPHZH', 'Katelynshire', 'phone'),
    ('Theresa', 'Denise', 'Wyatt', '1937-04-02', '65655 White Square, North Kathryn, DE 18718', 'F', 'Niger', '190-831-6761x7045', '0396', 'brenda30@example.com', 'NVBAWTLZHK', 'Sellersfurt', 'internet'),
    ('Joseph', 'Nicholas', 'Brewer', '1966-11-29', '615 Amy Station, West Kimton, KS 65938', 'M', 'Saint Barthelemy', '171-737-0302x01566', '662', 'brettrandall@example.org', 'IPVVGXUTNO', 'Castilloport', 'internet'),
    ('Nicholas', 'Sandy', 'Ball', '1992-08-27', '963 Vega Camp, Lake Sheri, AR 62508', 'M', 'Luxembourg', '371-872-0736x27869', '991', 'criley@example.com', 'BYGMNGJLRE', 'East Victoria', 'phone'),
    ('Jacob', 'Austin', 'Heath', '1945-04-16', '89872 Mckinney Brooks Suite 481, Port Nicoleton, NV 63681', 'M', 'Iraq', '098-195-7931x3869', '30319', 'sbriggs@example.org', 'CRZIVHBILZ', 'Smithport', 'counter'),
    ('Christopher', 'Stephen', 'Norton', '1940-11-03', '967 Dalton Plaza, Port Lisa, SD 74267', 'F', 'Tunisia', '+1-747-141-2961x0664', '752', 'lisa88@example.com', 'SFBLHLNHME', 'North Brandyton', 'counter'),
    ('Samantha', 'Susan', 'Harrell', '1946-07-07', '69609 Rodriguez Trail Suite 256, Johnsonville, ME 28911', 'M', 'Kenya', '(898)748-9683', '2554', 'afranklin@example.net', 'BHZGGPAFBA', 'West Jennifer', 'counter'),
    ('Raymond', 'Lisa', 'Soto', '1952-02-28', 'USS Harris, FPO AE 31070', 'F', 'Nicaragua', '005-742-0605x54677', '4502', 'chanson@example.com', 'AAKTPVMTSK', 'East Brentfort', 'internet'),
    ('Abigail', 'Brian', 'Perez', '1947-09-02', '074 Brandon Loop, New Dennis, OR 90891', 'F', 'Suriname', '(325)871-9753x682', '4148', 'ryanwilliams@example.com', 'TTDGQTWLCL', 'South Katrinachester', 'internet'),
    ('Melinda', 'Joel', 'Kirby', '1999-01-11', '0964 Green Knoll Apt. 244, Deborahmouth, AK 49915', 'M', 'Central African Republic', '059.097.1717x206', '686', 'barberrandall@example.net', 'DPZXHJZGDT', 'North Jeromefurt', 'internet'),
    ('Zachary', 'Tricia', 'Johnson', '1963-12-11', '1126 Jane Viaduct Apt. 481, New Terri, TN 83604', 'F', 'Morocco', '001-766-867-6958', '5072', 'schwartzkrista@example.net', 'XLOFVBOPAQ', 'Johnville', 'internet'),
    ('Helen', 'Tina', 'Carpenter', '1978-06-30', '2859 Peter Tunnel, Danielview, WV 89587', 'M', 'Papua New Guinea', '367-844-2707x5796', '850', 'rebeccabrown@example.org', 'RYCNRZQOZY', 'Michaelfurt', 'counter'),
    ('Barbara', 'Craig', 'White', '1994-10-01', '6585 Tonya Alley Suite 793, Lake Danielview, PW 21029', 'M', 'Solomon Islands', '001-562-171-4997x727', '687', 'loganflores@example.net', 'BVLAJUFTFD', 'New Carolport', 'counter'),
    ('Lisa', 'Sheila', 'Taylor', '1948-02-17', '6493 Angel Walk, North Amanda, AK 36259', 'M', 'Taiwan', '250-292-4066x48862', '27646', 'umalone@example.org', 'DGAFWNJSKV', 'Lake Joshua', 'phone'),
    ('Leah', 'Donald', 'Schwartz', '2001-01-13', '1215 George Inlet Apt. 650, Caseyville, CA 99681', 'F', 'British Virgin Islands', '(631)510-3513', '056', 'forbesjanet@example.net', 'GTLOMMEBQA', 'Juliehaven', 'internet'),
    ('Dustin', 'Noah', 'Garcia', '1957-05-30', '9992 Mcclure Islands Apt. 385, Contrerasshire, NM 57883', 'F', 'Bolivia', '+1-798-342-2110x02080', '01352', 'rstein@example.org', 'FRZMMBHUGR', 'Lake Johnathan', 'phone'),
    ('Jeff', 'William', 'Wall', '2002-03-30', '10033 Sara Forks Suite 101, Stephaniehaven, HI 47227', 'M', 'Saint Martin', '(758)577-6383', '88884', 'susan17@example.org', 'KBLPGILGVR', 'West Kathryn', 'counter'),
    ('Ashley', 'Ryan', 'Branch', '1955-08-03', '356 Christopher Curve, Thomasstad, PW 78757', 'F', 'San Marino', '+1-632-584-2396x34309', '454', 'tpatel@example.com', 'IRVMVOEPHU', 'North Josephton', 'internet'),
    ('Christine', 'Adam', 'Atkins', '1955-02-24', '6979 John Brook, Martinezbury, IA 99556', 'M', 'Palau', '+1-284-971-6806x74286', '27038', 'wgonzales@example.org', 'PESPUPKWBR', 'Lake Tiffanyland', 'internet'),
    ('Joshua', 'Julie', 'Jones', '1946-07-02', '313 Angela Meadow, Lake Timothy, KS 10390', 'M', 'Montenegro', '9963144613', '453', 'alexanderwhite@example.net', 'GOVLDZPZYI', 'Hortonhaven', 'internet'),
    ('Michael', 'Brittney', 'Torres', '1952-08-28', 'PSC 6299, Box 8006, APO AP 82082', 'F', 'El Salvador', '161.169.1689x64181', '93645', 'croberson@example.com', 'NYXRTCBXNH', 'West Tammy', 'counter'),
    ('Ryan', 'Madison', 'Watson', '1941-08-08', '81713 Dana Lakes, South Amy, NC 71235', 'M', 'Heard Island and McDonald Islands', '001-527-629-5460x77430', '53281', 'dmeyer@example.net', 'BWXKCSAJFK', 'Mosleyburgh', 'counter'),
    ('David', 'Jose', 'Thomas', '1992-04-20', '9934 Michelle Spring Apt. 110, East Dustinstad, MO 06609', 'F', 'Tokelau', '228.476.6554', '7576', 'sbeltran@example.org', 'RGCXPKPTFT', 'West Richardfurt', 'phone'),
    ('Karen', 'Nicole', 'Walton', '1991-04-28', '2012 Gibbs Divide, Hudsonside, FL 39941', 'M', 'Mozambique', '+1-327-949-4568', '038', 'kristinboyle@example.org', 'WWCEFQRGPC', 'Smithburgh', 'internet'),
    ('David', 'Robin', 'Medina', '1992-09-05', '0426 Cunningham Junctions Apt. 054, East Kimberly, AS 55697', 'M', 'Kyrgyz Republic', '942-542-4174x72958', '304', 'conradderek@example.org', 'XNMCOXTUAW', 'South Andrewchester', 'internet'),
    ('Deanna', 'Dustin', 'Mendez', '1933-12-21', '847 Waters Branch, Jensenbury, CA 97372', 'F', 'Djibouti', '4415101787', '04170', 'vlewis@example.org', 'ZBDEFOLSML', 'Millerstad', 'phone'),
    ('Ronald', 'Angela', 'Collins', '1966-09-08', '360 Thomas Fort Suite 883, Andersonberg, HI 67834', 'F', 'United Kingdom', '(873)942-9875x82224', '8557', 'kelliherring@example.com', 'MTXVWXAOFH', 'South Ericborough', 'phone'),
    ('Michael', 'Samantha', 'Nelson', '1946-01-03', 'PSC 9026, Box 4508, APO AP 38492', 'F', 'Costa Rica', '073-542-2970', '042', 'josepholson@example.com', 'DIFRNUDSXB', 'Ericport', 'phone'),
    ('Charles', 'Brian', 'Church', '1951-02-13', '1628 Reyes Pine Suite 737, Jessicaside, FM 43021', 'M', 'Saint Martin', '6105415302', '26164', 'sarah92@example.net', 'VOPDUKMMKC', 'North Patrick', 'counter'),
    ('Leah', 'Christine', 'Henry', '1954-02-21', '75936 Ellison Mount Apt. 830, Jessicamouth, KY 60127', 'F', 'Bolivia', '+1-436-067-3220x241', '6769', 'smitchell@example.com', 'SDRGCXMYOW', 'Reynoldstown', 'internet'),
    ('Sarah', 'Heather', 'Branch', '1968-06-13', '564 Willis Freeway, Perezberg, PW 12520', 'M', 'Finland', '035.561.9751x65194', '4738', 'matthewrios@example.com', 'RSGELEQKUB', 'Mendezfort', 'counter'),
    ('Nicholas', 'Eric', 'Hoffman', '1958-11-26', '06660 Jones Route, Andreaberg, VI 97353', 'F', 'Saint Martin', '247-736-3138', '792', 'jodonnell@example.net', 'AAAONDRPCR', 'Kimview', 'internet'),
    ('Misty', 'Kathy', 'Smith', '1985-10-02', '593 David Course, West Erica, HI 50731', 'M', 'Philippines', '972-017-7282', '1103', 'matthew15@example.com', 'ZVWNXJHDLW', 'East Rebeccaton', 'counter'),
    ('Lindsay', 'Jennifer', 'Martinez', '1984-05-14', '63681 Willis Plaza, Mccarthyside, KS 92320', 'F', 'Samoa', '696-698-0448x6799', '885', 'nathan52@example.net', 'TYMGAWYZWQ', 'Port Elaineberg', 'phone'),
    ('Arthur', 'Julie', 'Navarro', '1999-10-27', '780 Kim Shoals Apt. 470, New Amy, NH 38749', 'M', 'Guinea-Bissau', '(476)714-4171', '4697', 'gregorydavis@example.org', 'TYJAGBFIMM', 'South Linda', 'internet'),
    ('Amber', 'Tiffany', 'Lopez', '1941-12-26', '1345 Norton Shoal, Sullivanville, MA 61882', 'M', 'Bahamas', '585-014-4673', '2416', 'andersondiane@example.net', 'HUODMCPNTC', 'Markborough', 'counter');

insert into companions (guest_id, first_name, middle_name, last_name, relationship_to_guest, date_of_birth, email)
values
    (22, 'Brian', 'Matthew', 'Johnson', 'Family', '1951-07-17', 'powellchad@example.com'),
    (15, 'Christopher', 'Aaron', 'Holland', 'Friend', '1951-10-10', 'williamgardner@example.com'),
    (33, 'Elizabeth', 'Steven', 'Johnson', 'Colleague', '2003-03-06', 'qhenry@example.net'),
    (38, 'Luis', 'Courtney', 'Garcia', 'Family', '1937-05-03', 'christinamccormick@example.com'),
    (14, 'Kevin', 'Julie', 'Macias', 'Friend', '1996-10-25', 'daguirre@example.org'),
    (32, 'Paige', 'Matthew', 'Cabrera', 'Colleague', '1981-03-12', 'gordonkelly@example.com'),
    (15, 'Victoria', 'Zachary', 'Luna', 'Colleague', '1936-10-01', 'perry26@example.org'),
    (32, 'Joseph', 'Crystal', 'Brown', 'Family', '1994-02-16', 'igraham@example.org'),
    (35, 'Mario', 'Kristen', 'Weber', 'Family', '1980-12-03', 'kristopherlewis@example.com'),
    (40, 'Kyle', 'Jennifer', 'Bird', 'Colleague', '1972-09-19', 'harrisjasmin@example.org'),
    (45, 'Stephanie', 'Tina', 'Boone', 'Friend', '1951-07-10', 'tamara65@example.net'),
    (6, 'Shawn', 'Michael', 'Bonilla', 'Colleague', '1984-03-11', 'lindsaycarter@example.net'),
    (26, 'Kelly', 'Breanna', 'Gross', 'Friend', '1949-08-14', 'justinhowe@example.com'),
    (47, 'Sarah', 'Natalie', 'Hardy', 'Family', '1976-07-15', 'jerry97@example.net'),
    (19, 'Matthew', 'Jackie', 'Taylor', 'Friend', '1942-01-25', 'keithwilliams@example.net'),
    (35, 'Christian', 'Suzanne', 'Wheeler', 'Friend', '1934-06-22', 'frostmatthew@example.com'),
    (14, 'John', 'Erica', 'Copeland', 'Friend', '2003-03-29', 'chavezsandra@example.org'),
    (50, 'Danny', 'Larry', 'Rodriguez', 'Colleague', '1979-12-12', 'gabrielwoods@example.com'),
    (47, 'Christopher', 'Melissa', 'Conrad', 'Colleague', '1951-07-23', 'qgentry@example.com'),
    (26, 'Theodore', 'Matthew', 'Lawson', 'Friend', '1942-07-17', 'joshua43@example.net'),
    (4, 'Steven', 'Hailey', 'Wright', 'Colleague', '1967-03-30', 'fergusonmichael@example.com'),
    (48, 'Kenneth', 'Anne', 'Allen', 'Friend', '1952-01-17', 'fsutton@example.net'),
    (44, 'Mark', 'Roy', 'Harvey', 'Colleague', '1964-09-19', 'luisbrown@example.com'),
    (35, 'Juan', 'Amy', 'Hubbard', 'Friend', '1972-05-04', 'michaelajohnson@example.com'),
    (26, 'David', 'Michelle', 'Figueroa', 'Colleague', '1985-12-16', 'belinda79@example.com'),
    (37, 'Tara', 'John', 'Thompson', 'Colleague', '1952-01-12', 'oliverlaura@example.com'),
    (48, 'Cory', 'Darrell', 'Hicks', 'Friend', '1963-10-31', 'uholmes@example.org'),
    (36, 'Cody', 'Anthony', 'Smith', 'Colleague', '1951-02-11', 'virginiajohnson@example.com'),
    (50, 'Ashley', 'Charles', 'Miles', 'Friend', '1940-11-12', 'kayla89@example.net'),
    (41, 'Julie', 'David', 'Davis', 'Colleague', '1950-08-22', 'ythompson@example.org'),
    (36, 'Wendy', 'Brittany', 'Maldonado', 'Family', '1948-04-09', 'njones@example.org'),
    (42, 'Jared', 'Lori', 'Bailey', 'Family', '1966-07-29', 'john56@example.com'),
    (2, 'Brenda', 'Rebecca', 'Nguyen', 'Friend', '1940-12-09', 'haleyamber@example.net'),
    (50, 'Victor', 'Shannon', 'Jackson', 'Friend', '2003-11-16', 'brian32@example.net'),
    (10, 'Aaron', 'Debbie', 'Green', 'Family', '2001-10-11', 'patricia52@example.org'),
    (1, 'Michele', 'Jared', 'Hoffman', 'Colleague', '2002-11-14', 'nicoleholloway@example.org'),
    (50, 'Jennifer', 'Nathan', 'Cannon', 'Colleague', '1994-04-27', 'hhall@example.net'),
    (3, 'Benjamin', 'Brian', 'Wagner', 'Family', '1964-05-17', 'zbailey@example.org'),
    (36, 'Anna', 'Tony', 'Robinson', 'Friend', '2000-05-25', 'bclark@example.com'),
    (19, 'Jennifer', 'Kathleen', 'Ponce', 'Friend', '1961-07-19', 'kking@example.org'),
    (40, 'Monica', 'Michael', 'Drake', 'Colleague', '1986-02-01', 'charlesmay@example.com'),
    (11, 'Ebony', 'Bonnie', 'Hudson', 'Family', '1953-09-23', 'deborahgreene@example.org');

insert into departments (name, rating, description)
values
    ('Concierge', null,'Provides guests with information about local attractions and assists with booking tours, transportation, and other services' ),
    ('Maintenance', null, 'Takes care of repairs and upkeep of the hotel’s physical infrastructure'),
    ('Food and Beverage', null, 'Manages the hotel’s dining options, including restaurants, bars, room service, and catering for events'),
    ('Reception', null,'Handles guest check-ins, check-outs, and general inquiries'),
    ('Housekeeping', null, 'Responsible for cleaning and maintaining guest rooms and common areas'),
    ('Human Resources', null, 'Manages employee relations, recruitment, and staff welfare'),
    ('Finance', null, 'Handles the financial transactions, accounting, and budgeting for the hotel'),
    ('Sales and Marketing', null, 'Works on promoting the hotel, managing bookings, and partnerships'),
    ('IT Department', null, 'Manages the technology infrastructure of the hotel'),
    ('Spa and Wellness', null, 'Manages spa services, fitness centers, and recreational facilities'),
    ('Event Management', null, 'Coordinates conferences, meetings, and events hosted at the hotel'),
    ('Fitness', null, 'Manages gym access and personal training services'),
    ('Entertainment', null, 'Oversees nightclub access and other entertainment venues'),
    ('Transportation', null, 'Handles transportation services like limousine services and airport shuttles'),
    ('Security',null,  'Responsible for the safety and security of guests, staff, and hotel property'),
    ('Medical Services', null, 'Provides medical assistance and first aid to guests'),
    ('Kids Club', null, 'Offers specialized services and activities for children and families');

insert into agents (first_name, last_name, department, role)
values
    ('Emily', 'Smith', 1, 'Senior Concierge'),
    ('James', 'Johnson', 1, 'Concierge Agent'),
    ('Laura', 'Peters', 1, 'Guest Relations Specialist'),
    ('Samuel', 'Thompson', 1, 'Concierge Assistant'),
    ('Robert', 'Miller', 2, 'Maintenance Manager'),
    ('Michael', 'Davis', 2, 'Technician'),
    ('Olivia', 'White', 2, 'HVAC Specialist'),
    ('Jacob', 'Harris', 2, 'Electrician'),
    ('Jessica', 'Taylor', 3, 'F&B Manager'),
    ('Sarah', 'Moore', 3, 'Chef'),
    ('Daniel', 'Jackson', 3, 'Bartender'),
    ('Sophia', 'Martinez', 3, 'Pastry Chef'),
    ('Ethan', 'Clark', 3, 'Sommelier'),
    ('Christopher', 'Martinez', 4, 'Front Desk Manager'),
    ('Ashley', 'Hernandez', 4, 'Receptionist'),
    ('Ava', 'Davis', 4, 'Guest Service Representative'),
    ('Mason', 'Lewis', 4, 'Night Auditor'),
    ('Jennifer', 'Martinez', 5, 'Housekeeping Manager'),
    ('Joshua', 'Lopez', 5, 'Room Attendant'),
    ('Isabella', 'Walker', 5, 'Laundry Manager'),
    ('Liam', 'Hall', 5, 'Public Area Attendant'),
    ('Sophia', 'Wilson', 6, 'HR Manager'),
    ('Ethan', 'Anderson', 6, 'HR Coordinator'),
    ('Emma', 'Allen', 6, 'Training Coordinator'),
    ('Noah', 'Young', 6, 'Recruiter'),
    ('Isabella', 'Thomas', 7, 'Finance Director'),
    ('Matthew', 'Lee', 7, 'Accountant'),
    ('Charlotte', 'King', 7, 'Financial Analyst'),
    ('James', 'Wright', 7, 'Payroll Specialist'),
    ('Alexander', 'White', 8, 'Marketing Director'),
    ('Olivia', 'Harris', 8, 'Sales Executive'),
    ('Amelia', 'Scott', 8, 'Digital Marketing Specialist'),
    ('Benjamin', 'Green', 8, 'Sales Coordinator'),
    ('William', 'Clark', 9, 'IT Manager'),
    ('Ava', 'Lewis', 9, 'System Administrator'),
    ('Mia', 'Adams', 9, 'Network Engineer'),
    ('Logan', 'Baker', 9, 'Help Desk Technician'),
    ('Sophie', 'Walker', 10, 'Spa Manager'),
    ('Jacob', 'Young', 10, 'Wellness Specialist'),
    ('Harper', 'Gonzalez', 10, 'Massage Therapist'),
    ('Alexander', 'Nelson', 10, 'Yoga Instructor'),
    ('Abigail', 'Allen', 11, 'Events Coordinator'),
    ('Dylan', 'King', 11, 'Event Planner'),
    ('Elijah', 'Carter', 11, 'Event Technology Coordinator'),
    ('Evelyn', 'Mitchell', 11, 'Wedding Planner'),
    ('Benjamin', 'Wright', 12, 'Gym Manager'),
    ('Mia', 'Scott', 12, 'Personal Trainer'),
    ('Abigail', 'Perez', 12, 'Aerobics Instructor'),
    ('William', 'Roberts', 12, 'Fitness Consultant'),
    ('Charlotte', 'Green', 13, 'Entertainment Manager'),
    ('Jack', 'Adams', 13, 'DJ'),
    ('Emily', 'Turner', 13, 'Event Entertainer'),
    ('Henry', 'Phillips', 13, 'Club Promoter'),
    ('Amelia', 'Baker', 14, 'Transport Manager'),
    ('Logan', 'Gonzalez', 14, 'Chauffeur'),
    ('Zoey', 'Campbell', 14, 'Fleet Manager'),
    ('Jack', 'Parker', 14, 'Driver Coordinator'),
    ('Noah', 'Nelson', 15, 'Security Chief'),
    ('Liam', 'Carter', 15, 'Security Officer'),
    ('John', 'Doe', 15, 'Security Officer'),
    ('Alan', 'Gus', 15, 'Security Officer'),
    ('Aiden', 'Evans', 15, 'Security Patrol Officer'),
    ('Scarlett', 'Edwards', 15, 'CCTV Operator'),
    ('Emma', 'Mitchell', 16, 'Medical Officer'),
    ('Oliver', 'Perez', 16, 'Nurse'),
    ('Lucas', 'Collins', 16, 'First Aid Responder'),
    ('Sofia', 'Stewart', 16, 'Health and Safety Coordinator'),
    ('Lucas', 'Roberts', 17, 'Kids Club Coordinator'),
    ('Ella', 'Turner', 17, 'Child Care Specialist'),
    ('Chloe', 'Sanchez', 17, 'Children’s Activities Coordinator'),
    ('Gabriel', 'Morris', 17, 'Playroom Supervisor');

insert into packages (name, start_date, end_date, room_category, description, discount)
values
    ('Standard Relaxation Package', '2023-03-01', '2024-01-31', 1, 'Includes daily housekeeping and access to the fitness center.', 10),
    ('Standard Business Package', '2023-11-01', '2023-12-31', 1, 'Includes high-speed internet access and business center facilities.', 15),
    ('Deluxe Spa Package', '2023-01-01', '2023-11-30', 2, 'Includes luxury spa treatments and private cabana rentals.', 20),
    ('Deluxe Gourmet Experience', '2023-01-01', '2023-06-28', 2, 'A culinary adventure with our fine dining restaurant and poolside bar service.', 15),
    ('Suite Executive Package', '2023-06-01', '2024-12-21', 3, 'Tailored for business travelers with executive business center access and limousine service.', 20),
    ('Suite Leisure Package', '2023-01-01', '2024-03-21', 3, 'Includes VIP nightclub access and city tours.', 25),
    ('Family Fun Package', '2023-08-01', '2023-10-21', 4, 'Family-oriented activities including city tours and entertainment park tickets.', 15),
    ('Family Wellness Package', '2023-04-01', '2023-11-21', 4, 'Wellness activities for the whole family, with spa treatments and yoga sessions.', 20),
    ('Executive Comfort Package', '2023-05-01', '2023-06-30', 5, 'All about comfort: room service, daily housekeeping, and access to the fitness center.', 10),
    ('Executive Networking Package', '2023-02-01', '2023-03-30', 5, 'Includes business center facilities and networking opportunities in our VIP lounge.', 15),
    ('Presidential Luxury Experience', '2023-07-01', '2023-08-30', 6, 'The epitome of luxury: includes helicopter rides, yacht rentals, and gourmet dining experiences.', 30),
    ('Presidential Relaxation Package', '2023-01-01', '2023-12-30', 6, 'Ultimate relaxation with spa treatments, personal shopper services, and private cabana rentals.', 25);

insert into reservations (room_id, agent_id, room_category, guest_id, method, package, status, check_in, check_out, date, hour, duration, subtotal)
values
    (46, 1, 1, 21, 'internet', 2, 'pending', '2023-10-27', '2024-03-20', '2023-03-12', '16:25:17', 9, 164.72),
    (25, 2, 3, 45, 'counter', 4, 'in progress', '2022-12-16', '2024-04-07', '2023-02-20', '13:51:13', 8, 251.56),
    (39, 3, 2, 12, 'internet', 1, 'pending', '2023-11-06', '2024-05-03', '2023-04-14', '03:16:04', 8, 434.69),
    (16, 4, 6, 9, 'counter', 4, 'cancelled', '2023-08-11', '2023-08-30', '2023-10-09', '08:07:40', 11, 436.39),
    (8, 5, 7, 35, 'internet', 2, 'pending', '2023-11-23', '2024-09-15', '2023-06-02', '06:30:19', 3, 477.00),
    (35, 6, 2, 1, 'phone', 9, 'pending', '2023-04-28', '2023-12-12', '2023-10-10', '09:06:49', 14, 55.45),
    (50, 7, 8, 25, 'internet', 6, 'in progress', '2023-07-22', '2024-04-21', '2023-04-24', '02:09:26', 6, 200.43),
    (45, 8, 5, 45, 'internet', 3, 'pending', '2023-11-04', '2024-02-05', '2023-03-05', '05:22:57', 12, 87.93),
    (4, 9, 7, 16, 'phone', 4, 'in progress', '2022-12-14', '2023-12-31', '2023-10-01', '08:07:28', 12, 471.60),
    (7, 10, 1, 33, 'phone', 12, 'expired', '2023-03-30', '2024-06-01', '2023-04-14', '05:36:31', 13, 287.24),
    (29, 11, 3, 32, 'counter', 2, 'pending', '2023-06-09', '2024-03-21', '2023-07-23', '20:07:05', 9, 69.35),
    (50, 12, 3, 30, 'internet', 9, 'in progress', '2023-05-31', '2023-08-22', '2023-09-04', '05:50:33', 3, 270.41),
    (19, 13, 4, 27, 'internet', 1, 'in progress', '2023-09-23', '2024-09-10', '2023-09-08', '18:09:18', 14, 286.05),
    (2, 14, 7, 41, 'internet', 4, 'in progress', '2023-01-13', '2024-07-09', '2023-06-17', '17:10:45', 12, 322.96),
    (3, 15, 2, 2, 'counter', 1, 'completed', '2023-06-22', '2023-11-26', '2023-11-10', '07:40:37', 6, 132.70),
    (25, 16, 1, 34, 'internet', 9, 'in progress', '2023-09-28', '2024-05-26', '2023-06-17', '08:05:20', 2, 319.75),
    (24, 17, 2, 4, 'internet', 12, 'pending', '2023-01-16', '2024-02-06', '2023-10-17', '09:24:51', 4, 177.60),
    (33, 18, 7, 50, 'internet', 7, 'in progress', '2023-07-14', '2024-07-12', '2023-06-20', '17:16:21', 1, 437.67),
    (2, 19, 6, 17, 'counter', 9, 'completed', '2023-02-04', '2023-07-15', '2023-03-16', '09:30:34', 12, 443.05),
    (25, 20, 6, 42, 'phone', 9, 'completed', '2023-06-11', '2023-07-30', '2023-04-19', '06:06:12', 8, 402.05),
    (5, 21, 1, 15, 'counter', 12, 'completed', '2023-11-20', '2024-03-04', '2023-08-06', '11:49:12', 13, 106.19),
    (22, 22, 5, 19, 'counter', 10, 'in progress', '2023-07-19', '2023-08-27', '2023-09-10', '09:06:53', 13, 182.09),
    (40, 23, 5, 47, 'internet', 4, 'pending', '2023-12-01', '2024-03-16', '2023-11-14', '15:27:27', 8, 151.29),
    (34, 24, 4, 29, 'phone', 6, 'expired', '2022-12-20', '2024-07-20', '2023-08-30', '00:39:57', 4, 464.50),
    (38, 25, 8, 26, 'counter', 3, 'cancelled', '2023-07-28', '2024-03-01', '2023-10-17', '01:06:49', 6, 222.72),
    (35, 26, 2, 41, 'internet', 5, 'expired', '2023-01-20', '2024-09-25', '2023-11-29', '00:44:01', 2, 171.00),
    (47, 27, 7, 41, 'phone', 3, 'cancelled', '2023-05-16', '2023-06-17', '2023-07-10', '20:38:29', 12, 249.66),
    (12, 28, 8, 12, 'counter', 2, 'completed', '2023-03-06', '2024-07-22', '2023-11-20', '14:25:39', 7, 426.54),
    (50, 29, 8, 13, 'counter', 12, 'pending', '2023-08-09', '2024-01-26', '2023-04-08', '00:01:51', 4, 206.15),
    (26, 30, 3, 23, 'phone', 2, 'pending', '2023-01-02', '2024-04-06', '2023-01-29', '05:19:05', 12, 126.03),
    (49, 31, 2, 34, 'phone', 9, 'in progress', '2023-04-26', '2024-07-11', '2023-07-07', '07:27:41', 11, 425.86),
    (36, 32, 3, 14, 'internet', 7, 'completed', '2023-09-24', '2023-12-01', '2023-06-19', '02:29:23', 6, 244.92),
    (14, 33, 7, 46, 'counter', 6, 'in progress', '2023-04-24', '2023-08-15', '2023-07-15', '16:27:51', 8, 302.34),
    (8, 34, 7, 30, 'phone', 2, 'in progress', '2022-12-11', '2023-05-10', '2023-05-12', '05:15:26', 2, 185.65),
    (32, 35, 3, 25, 'counter', 4, 'pending', '2023-02-13', '2023-03-15', '2023-05-31', '14:09:09', 4, 412.00),
    (46, 36, 6, 12, 'phone', 1, 'in progress', '2023-09-10', '2023-12-27', '2023-01-22', '01:08:07', 3, 269.24),
    (20, 37, 5, 40, 'internet', 5, 'expired', '2023-06-07', '2024-08-17', '2023-02-12', '01:10:55', 3, 219.69),
    (23, 38, 7, 26, 'counter', 12, 'completed', '2023-07-25', '2024-08-05', '2023-10-18', '13:53:20', 12, 338.39),
    (23, 39, 6, 35, 'phone', 6, 'completed', '2023-07-21', '2024-07-23', '2023-07-21', '08:26:40', 8, 334.19),
    (5, 40, 6, 1, 'internet', 8, 'completed', '2023-05-15', '2023-11-22', '2023-01-04', '10:51:11', 14, 298.23),
    (40, 41, 3, 31, 'counter', 7, 'pending', '2023-06-18', '2024-04-08', '2022-12-07', '14:36:52', 13, 329.22),
    (43, 42, 1, 37, 'internet', 7, 'pending', '2023-12-03', '2024-02-28', '2023-11-28', '00:24:20', 9, 244.65),
    (44, 43, 6, 4, 'phone', 6, 'completed', '2023-09-06', '2024-11-28', '2023-10-29', '14:32:54', 4, 205.38),
    (33, 44, 4, 11, 'internet', 1, 'completed', '2023-03-25', '2024-03-13', '2023-09-23', '23:00:04', 6, 173.48),
    (40, 45, 8, 37, 'internet', 10, 'cancelled', '2023-06-08', '2024-10-31', '2023-02-15', '10:30:41', 11, 407.24),
    (9, 46, 8, 17, 'phone', 7, 'pending', '2023-11-17', '2024-07-01', '2023-03-17', '07:37:09', 2, 69.92),
    (3, 47, 6, 30, 'internet', 10, 'pending', '2023-12-02', '2024-08-20', '2023-07-01', '10:01:41', 14, 368.08),
    (38, 48, 5, 34, 'internet', 11, 'cancelled', '2022-12-07', '2024-09-06', '2023-10-18', '12:58:17', 14, 397.04),
    (33, 49, 8, 39, 'counter', 4, 'cancelled', '2023-11-06', '2024-10-18', '2023-10-03', '01:51:34', 7, 268.89),
    (4, 50, 2, 4, 'internet', 12, 'pending', '2023-03-12', '2024-08-20', '2023-10-22', '17:56:05', 6, 183.33);

insert into services (type, name, department, price)
values
    ('internal', '24-hour Room Service', 3, 50),        -- Food and Beverage
    ('internal', 'Daily Housekeeping', 5, 0),           -- Housekeeping
    ('internal', 'Luxury Spa Treatments', 11, 150),     -- Spa and Wellness
    ('internal', 'Fitness Center Access', 12, 25),      -- Fitness
    ('internal', 'Fine Dining Restaurant', 3, 100),     -- Food and Beverage
    ('internal', 'Poolside Bar Service', 3, 30),        -- Food and Beverage
    ('internal', 'Personal Trainer Sessions', 12, 70),  -- Fitness
    ('internal', 'Private Cabana Rentals', 13, 120),    -- Recreational Services
    ('internal', 'VIP Nightclub Access', 13, 90),       -- Entertainment
    ('internal', 'Executive Business Center', 7, 0),    -- Business Services
    ('internal', 'Golf Course Privileges', 13, 180),    -- Recreational Services
    ('internal', 'Concierge Services', 1, 0),           -- Reception/Concierge
    ('internal', 'Limousine Service', 14, 400),         -- Transportation
    ('external', 'City Tours', 1, 75),
    ('external', 'Cultural Excursions', 1, 90),
    ('external', 'Helicopter Rides', 1, 300),
    ('external', 'Theater Tickets Booking', 1, 110),
    ('external', 'Luxury Yacht Rentals', 1, 400),
    ('external', 'Personal Shopper', 1, 150),
    ('damage', 'Smoking Penalty Fee', 5, 250),
    ('damage', 'Pet Cleaning Fee', 5, 100);

insert into consumptions (reservation_id, service_id, department, date, hour, subtotal)
values
    (14, 14, 7, '2023-06-29', '21:54:56', 195.86),
    (43, 20, 10, '2023-06-07', '07:03:41', 138.81),
    (50, 17, 13, '2023-04-17', '19:36:17', 343.76),
    (4, 16, 2, '2023-07-11', '14:42:10', 407.52),
    (43, 13, 7, '2023-06-22', '00:49:49', 254.76),
    (4, 15, 2, '2023-02-22', '18:59:03', 84.98),
    (15, 12, 3, '2023-10-18', '19:24:33', 86.50),
    (18, 19, 8, '2022-12-09', '08:43:13', 379.39),
    (14, 5, 2, '2023-08-27', '13:14:43', 252.41),
    (46, 3, 14, '2023-08-09', '20:40:29', 476.63),
    (27, 9, 17, '2023-07-18', '15:35:38', 453.13),
    (5, 1, 9, '2023-03-29', '13:20:27', 450.06),
    (6, 4, 1, '2023-02-05', '22:08:31', 484.89),
    (4, 2, 7, '2023-07-23', '21:08:50', 475.53),
    (30, 19, 13, '2023-05-27', '02:45:08', 157.14),
    (31, 8, 14, '2023-04-27', '22:32:19', 265.73),
    (5, 8, 2, '2023-11-21', '07:22:53', 180.07),
    (49, 14, 14, '2023-05-04', '08:54:30', 311.02),
    (42, 10, 15, '2023-03-15', '10:40:44', 429.13),
    (16, 9, 8, '2022-12-24', '10:03:06', 96.17),
    (17, 6, 13, '2023-06-28', '17:22:45', 366.60),
    (48, 15, 3, '2023-11-20', '23:26:16', 259.73),
    (22, 11, 12, '2023-08-26', '03:54:04', 171.60),
    (41, 9, 10, '2023-01-05', '17:38:55', 476.07),
    (39, 5, 6, '2023-04-21', '04:05:25', 325.78),
    (29, 6, 7, '2023-02-27', '09:56:44', 483.93),
    (29, 17, 17, '2023-01-16', '16:48:29', 76.28),
    (50, 20, 8, '2023-08-02', '12:26:34', 390.37),
    (22, 3, 11, '2023-09-24', '22:28:49', 122.90),
    (5, 21, 12, '2023-11-13', '20:55:07', 373.22),
    (11, 9, 12, '2023-09-23', '22:01:38', 186.86),
    (23, 12, 6, '2022-12-12', '16:27:47', 374.01),
    (34, 12, 13, '2023-09-02', '15:38:52', 95.61),
    (11, 13, 5, '2023-08-02', '02:42:50', 198.91),
    (3, 5, 6, '2023-07-12', '21:34:52', 428.56),
    (16, 15, 15, '2023-08-12', '18:23:14', 359.81),
    (25, 4, 5, '2023-03-11', '00:41:52', 314.78),
    (44, 1, 7, '2023-08-16', '14:21:59', 68.19),
    (37, 5, 16, '2023-11-27', '10:05:03', 113.58),
    (9, 14, 15, '2023-04-14', '04:20:34', 61.56),
    (13, 14, 13, '2023-01-21', '15:00:38', 185.14),
    (19, 14, 15, '2023-06-22', '16:42:51', 196.44),
    (43, 18, 8, '2023-01-10', '16:24:15', 296.56),
    (3, 3, 13, '2023-01-17', '17:17:36', 413.73),
    (34, 9, 6, '2023-05-02', '22:53:06', 378.88),
    (20, 16, 2, '2023-11-27', '02:27:55', 135.35),
    (40, 5, 11, '2023-03-23', '12:30:05', 213.32),
    (1, 9, 2, '2023-12-03', '09:55:08', 259.04),
    (29, 3, 13, '2023-05-25', '09:29:07', 52.45),
    (14, 10, 5, '2023-08-03', '16:50:25', 495.42);

insert into final_bills (reservation_id, total_room_charge, total_services_charge, total_package_charge, total_amount, issued_date, status)
values
    (15, 411.75, 289.84, 89.29, 790.88, '2023-05-04', 'paid'),
    (35, 57.96, 399.42, 485.09, 942.47, '2023-05-08', 'paid'),
    (31, 139.13, 77.97, 110.64, 327.74, '2023-05-30', 'pending'),
    (33, 97.86, 450.27, 447.51, 995.64, '2023-06-21', 'pending'),
    (8, 76.22, 136.11, 252.31, 464.64, '2023-10-13', 'pending'),
    (18, 456.81, 162.41, 274.33, 893.55, '2023-08-10', 'paid'),
    (7, 63.3, 434.12, 328.69, 826.11, '2022-12-21', 'paid'),
    (3, 88.92, 182.44, 348.66, 620.02, '2023-05-29', 'pending'),
    (8, 188.38, 134.14, 398.39, 720.91, '2023-08-05', 'paid'),
    (6, 313.22, 194.7, 136.11, 644.03, '2023-03-13', 'pending'),
    (19, 297.46, 392.3, 174.67, 864.43, '2022-12-31', 'paid'),
    (9, 335.7, 394.09, 432.67, 1162.46, '2022-12-24', 'pending'),
    (38, 466.81, 484.08, 293.24, 1244.13, '2023-02-15', 'pending'),
    (49, 361.52, 322.61, 304.43, 988.56, '2023-06-16', 'pending'),
    (44, 78.21, 305.21, 288.81, 672.23, '2023-07-31', 'paid'),
    (28, 194.61, 479.16, 279.76, 953.53, '2023-12-01', 'paid'),
    (38, 315.11, 479.76, 81.83, 876.7, '2023-02-24', 'pending'),
    (35, 207.61, 347.85, 166.6, 722.06, '2023-04-02', 'paid'),
    (36, 309.03, 337.24, 494.6, 1140.87, '2022-12-04', 'pending'),
    (29, 238.37, 121.16, 482.15, 841.68, '2022-12-22', 'pending'),
    (31, 384.4, 390.38, 290.88, 1065.66, '2023-04-11', 'paid'),
    (25, 420.4, 457.68, 494.92, 1373.0, '2023-08-24', 'pending'),
    (12, 181.04, 439.88, 357.64, 978.56, '2023-02-03', 'pending'),
    (26, 440.23, 469.99, 460.29, 1370.51, '2023-05-15', 'paid'),
    (32, 88.05, 54.72, 80.11, 222.88, '2023-06-26', 'paid'),
    (17, 445.27, 183.2, 133.35, 761.82, '2023-02-11', 'paid'),
    (40, 459.32, 483.06, 127.03, 1069.41, '2023-06-27', 'pending'),
    (43, 357.39, 131.26, 423.31, 911.96, '2023-06-02', 'paid'),
    (49, 176.3, 52.32, 118.48, 347.1, '2023-06-01', 'paid'),
    (24, 78.06, 444.68, 382.32, 905.06, '2023-01-28', 'pending'),
    (25, 326.7, 400.26, 210.8, 937.76, '2023-11-25', 'pending'),
    (42, 184.3, 389.83, 374.8, 948.93, '2023-03-08', 'pending'),
    (13, 242.16, 221.98, 83.72, 547.86, '2023-11-24', 'pending'),
    (24, 226.32, 116.56, 317.07, 659.95, '2023-04-03', 'paid'),
    (15, 265.74, 296.48, 306.99, 869.21, '2023-05-27', 'pending'),
    (29, 430.04, 395.75, 62.48, 888.27, '2023-04-14', 'paid'),
    (50, 245.3, 325.8, 233.36, 804.46, '2023-07-23', 'pending'),
    (34, 445.62, 141.61, 444.37, 1031.6, '2023-09-26', 'paid'),
    (50, 57.94, 402.41, 125.56, 585.91, '2023-07-15', 'paid'),
    (22, 453.83, 75.31, 132.1, 661.24, '2023-06-02', 'paid'),
    (48, 419.27, 323.88, 88.57, 831.72, '2023-05-10', 'pending'),
    (20, 416.91, 455.88, 278.94, 1151.73, '2023-03-10', 'paid'),
    (47, 254.8, 486.86, 439.05, 1180.71, '2023-04-02', 'pending'),
    (48, 74.48, 127.63, 123.32, 325.43, '2023-04-22', 'pending'),
    (33, 364.76, 174.75, 152.72, 692.23, '2023-10-31', 'pending'),
    (4, 267.82, 227.17, 139.27, 634.26, '2023-04-26', 'pending'),
    (5, 132.96, 261.53, 412.38, 806.87, '2023-10-15', 'paid'),
    (46, 122.44, 490.36, 296.61, 909.41, '2023-07-22', 'pending'),
    (16, 408.19, 302.92, 143.0, 854.11, '2023-09-10', 'pending'),
    (30, 135.77, 191.72, 292.99, 620.48, '2023-01-02', 'paid');

insert into package_mapping (package_id, room_service_id)
values
    (1, 23),
    (1, 25),
    (2, 38),
    (2, 26),
    (3, 24),
    (3, 29),
    (4, 26),
    (4, 27),
    (5, 32),
    (5, 30),
    (6, 35),
    (6, 30),
    (7, 35),
    (7, 38),
    (8, 24),
    (8, 29),
    (9, 23),
    (9, 25),
    (10, 31),
    (10, 32),
    (11, 39),
    (11, 40),
    (12, 24),
    (12, 29);

insert into feedback (reservation_id, department, description, date, rating, issue_type)
values
    (42, 14, 'Toward soon remain past must section. Seat deal lay left commercial. Time north whole far.
    Almost write his live quickly. Care operation similar social.', '2023-12-02', 1, 'Suggestion'),
    (43, 8, 'Recognize peace visit soon difference remember door. Reach recent read road against sport. System fact election start away work.', '2023-05-22', 5, 'Praise'),
    (26, 6, 'Example himself mention. Audience outside item early. Start century defense explain table authority.
    First outside college care. Agency use goal.', '2022-12-05', 2, 'Complaint'),
    (20, 7, 'Chair movement space include feel instead. Need star difference agreement attention. Begin chair condition deep short.', '2023-08-11', 1, 'Complaint'),
    (19, 7, 'Travel record turn particularly charge. Skill likely billion much professor management speech.
    Sea analysis control issue particular. Season four analysis future environment.', '2023-06-01', 2, 'Complaint'),
    (8, 12, 'Trial how successful network traditional firm side. You school son beyond east.', '2023-05-07', 1, 'Praise'),
    (16, 14, 'Prevent inside clearly message collection. More recent spend now theory action space available.
    Population measure pretty artist discussion.', '2023-02-21', 3, 'Complaint'),
    (34, 3, 'Father start lose item six ok camera. School enjoy fund stuff close candidate can hundred. Fire dog land world seven.', '2022-12-05', 2, 'Complaint'),
    (38, 1, 'Foreign maybe eat must too add truth. Experience why job series class carry thousand. American increase school practice hear five.', '2023-01-10', 3, 'Complaint'),
    (48, 17, 'Marriage foreign simple listen ready me every. Church food way company ground huge. Field road these five rock strategy these.
    Alone investment lose. Safe and yourself art.', '2023-03-26', 4, 'Praise'),
    (6, 4, 'Either growth family appear take. Lot guess use between raise term follow.', '2023-09-03', 2, 'Praise'),
    (39, 13, 'Least mention build house fact nice. Clear they network religious. After beyond leg minute bank.', '2023-04-22', 5, 'Suggestion'),
    (48, 11, 'Guess any draw general. Question upon just. Give paper southern few product them.
    Maintain product suffer better show front face.
    Key against forward soldier wish five. Rule never police economic.', '2023-02-10', 5, 'Praise'),
    (33, 5, 'Tough for teach yes city necessary. Close environment film short challenge quality help bit.
    Political movement chair indicate computer page. But now structure officer turn card both.', '2023-05-07', 5, 'Suggestion'),
    (30, 1, 'Well under must among administration. Instead Mr store fund.
    Join modern from style air surface series. Hundred bit rest first week shake side on.', '2023-03-01', 2, 'Praise'),
    (3, 11, 'Southern tend local yard. Eye financial rather. Physical approach everybody audience. Effect will no deep.
    Happy push should full.', '2023-06-05', 5, 'Praise'),
    (41, 5, 'There itself agent. Fire use sea relationship. Great accept Democrat receive former affect rule. Play between catch structure here account memory.', '2023-04-18', 5, 'Praise'),
    (18, 17, 'Challenge outside Mrs. General include perhaps focus. Everyone beyond high food.
    Skin few pass. Occur power its professor shoulder ask event. Tree week media fact his know.', '2023-04-02', 5, 'Suggestion'),
    (49, 6, 'Similar design body perform. Decision senior join there. Charge miss past wife.
    Agree view series moment free soon.
    Plant hair many party knowledge. Mother source expert amount go force enter.', '2023-02-01', 1, 'Suggestion'),
    (13, 5, 'Difficult oil chance audience its. Them finish local picture benefit star. Class not weight full world Congress woman war. Major report task nothing him father.', '2023-01-31', 3, 'Praise'),
    (26, 3, 'Pretty cut whose involve company move. Idea measure forward example sense. None attorney total relationship art maintain.', '2023-06-15', 4, 'Praise'),
    (6, 14, 'Draw suggest store issue leave address red street. First simple treat body once remember long. Enjoy past number store.', '2023-10-17', 2, 'Praise'),
    (1, 10, 'Group character likely respond. Visit deal image himself four vote rest. Officer water down sport.', '2022-12-24', 2, 'Suggestion'),
    (24, 9, 'Respond outside adult program usually subject detail. Surface economic seat begin reduce. Early section chance article.', '2023-11-14', 1, 'Praise'),
    (22, 7, 'Yet lose material address almost record. Less movie chair election wish. Mission information person everybody Mr former.
    Should market soldier. Somebody minute later each.
    Land try why director.', '2023-04-12', 4, 'Suggestion'),
    (33, 7, 'Great live box north either network book. Imagine it day space draw.
    Scene campaign special adult. Out provide already within. Home remain consider involve.', '2023-02-25', 4, 'Complaint'),
    (35, 15, 'Tree firm best most risk. Maintain box bar ago article lose cut shake. Plant design director serve upon plan arm director.', '2023-04-11', 2, 'Complaint'),
    (16, 3, 'Much front never enjoy.
    Shake author thus produce seat own exactly.
    Activity where business improve home. Paper reason put time us keep often.
    One fire professor together indeed.', '2023-01-26', 2, 'Praise'),
    (22, 4, 'Poor all nearly character resource American fine ask. Vote become of determine executive boy sort.', '2023-01-20', 3, 'Complaint'),
    (34, 11, 'With manage moment me song. His model reality. Amount dream how sure entire between theory.
    Grow answer remember per. Form condition usually street. Religious rise expect pretty indeed.', '2023-02-27', 2, 'Suggestion'),
    (38, 6, 'Build part stuff wife. Despite television project cell book hour.
    Management east board meet.
    Pm skin power court green pretty mean. Thought all woman machine quickly take best become.', '2023-03-16', 2, 'Praise'),
    (49, 10, 'Onto gas too move. Your describe she true ever treatment. Medical traditional morning task civil all forget.', '2023-08-14', 4, 'Complaint'),
    (44, 1, 'Positive red scientist environment lead price method. Lot might poor building resource. Rich walk surface before industry trip.', '2023-06-07', 5, 'Complaint'),
    (8, 1, 'Increase total building also behind base. Boy great mind leader can sense key. Notice eight skill news off brother oil.', '2023-11-12', 4, 'Praise'),
    (29, 1, 'About prevent major former choose street. Friend really partner after enough act little.
    Old research off position water.', '2023-09-06', 4, 'Complaint'),
    (43, 9, 'Show meeting right. House write worker audience Congress why.
    Cover step music without future. Score I environmental serve however approach writer. Coach his reveal partner draw.', '2023-03-19', 1, 'Praise'),
    (26, 13, 'Amount start build three herself. Beautiful else because heart. Morning which similar factor hospital development.', '2023-06-08', 5, 'Suggestion'),
    (40, 3, 'Middle who less everything. Space enjoy over form left professor.', '2023-08-09', 2, 'Suggestion'),
    (14, 12, 'Well truth land owner. Step every should hotel black strong affect family. Event west back behind energy.
    Team trip choose film. Off interview report moment five. Statement yeah affect soon late.', '2023-07-30', 3, 'Suggestion'),
    (29, 4, 'Activity teacher offer under who though wind compare. Accept peace push might among leave despite.', '2023-02-26', 5, 'Complaint'),
    (7, 6, 'Wonder something detail pretty. Both after least shoulder blood head center.', '2023-04-06', 4, 'Suggestion'),
    (13, 3, 'Player close behavior himself central hotel attention management. Teacher Mrs better however house early certainly I.
    Later service people majority group air. Visit allow note drug past serious.', '2023-02-03', 5, 'Praise'),
    (24, 10, 'Between big environment class project sing eye understand. Hotel these adult player industry.', '2023-08-08', 3, 'Praise'),
    (47, 7, 'Believe church contain worker society prove television world. Movement reveal worry side door sing either.
    Age light Congress score month prepare. Surface run scene attorney.', '2023-02-14', 1, 'Praise'),
    (23, 15, 'Yes edge ball. Majority five sister interesting worker focus. Detail sure discover return those cover. List question his these left.', '2023-05-20', 3, 'Complaint'),
    (48, 7, 'Rather gun little role. Operation cut study happen. Player community resource doctor cup rich form.
    Here less whatever left reduce market might. Everyone size seven training cup between show.', '2023-07-09', 3, 'Praise'),
    (26, 2, 'Reason catch realize factor tax commercial. Under trial draw care although room. Like election travel surface partner.', '2023-10-13', 1, 'Suggestion'),
    (9, 4, 'Whose various pay behavior American fact. Statement respond better reduce behavior. A allow since week. Capital drug total simple list thought.', '2023-12-03', 4, 'Praise'),
    (46, 8, 'Economic really maintain early control position. Though sell street money trade relationship let commercial.', '2023-02-12', 5, 'Praise'),
    (13, 14, 'As far animal great natural from director.
    Image single customer operation. Image anything road capital.
    Ability make century standard task. Card more bill former.', '2023-02-13', 2, 'Suggestion');

-- room_services insertions
CALL add_service_and_map_to_rooms('internal', '24-hour Room Service', 3, 50.00, ARRAY[1, 2, 3, 4, 5, 6, 7, 8]);
CALL add_service_and_map_to_rooms('internal', 'Daily Housekeeping', 5, 0.00, ARRAY[1, 2, 3, 4, 5, 6, 7, 8]);
CALL add_service_and_map_to_rooms('internal', 'Luxury Spa Treatments', 11, 150.00, ARRAY[2, 3, 4, 6]);
CALL add_service_and_map_to_rooms('internal', 'Fitness Center Access', 12, 25.00, ARRAY[1, 2, 3, 4, 5, 6, 7, 8]);
CALL add_service_and_map_to_rooms('internal', 'Fine Dining Restaurant', 3, 100.00, ARRAY[1, 2, 3, 4, 5, 6, 7, 8]);
CALL add_service_and_map_to_rooms('internal', 'Poolside Bar Service', 3, 30.00, ARRAY[1, 2, 3, 4, 5, 6, 7, 8]);
CALL add_service_and_map_to_rooms('internal', 'Personal Trainer Sessions', 12, 70.00, ARRAY[2, 3, 4, 6]);
CALL add_service_and_map_to_rooms('internal', 'Private Cabana Rentals', 13, 120.00, ARRAY[1, 2, 3, 4, 5, 6, 7, 8]);
CALL add_service_and_map_to_rooms('internal', 'VIP Nightclub Access', 13, 90.00, ARRAY[2, 3, 5, 6]);
CALL add_service_and_map_to_rooms('internal', 'Executive Business Center', 7, 0.00, ARRAY[5, 6]);
CALL add_service_and_map_to_rooms('internal', 'Golf Course Privileges', 13, 180.00, ARRAY[3, 5, 6]);
CALL add_service_and_map_to_rooms('internal', 'Concierge Services', 1, 0.00, ARRAY[1, 2, 3, 4, 5, 6, 7, 8]);
CALL add_service_and_map_to_rooms('internal', 'Limousine Service', 14, 400.00, ARRAY[5, 6]);
CALL add_service_and_map_to_rooms('external', 'City Tours', 1, 75.00, ARRAY[1, 2, 3, 4, 5, 6, 7, 8]);
CALL add_service_and_map_to_rooms('external', 'Cultural Excursions', 1,90.00, ARRAY[1, 2, 3, 4, 5, 6, 7, 8]);
CALL add_service_and_map_to_rooms('external', 'Helicopter Rides', 1, 2000.00, ARRAY[5, 6]);
CALL add_service_and_map_to_rooms('external', 'Theater Tickets Booking', 1, 40.00, ARRAY[1, 2, 3, 4, 5, 6, 7, 8]);
CALL add_service_and_map_to_rooms('external', 'Luxury Yacht Rentals', 1, 2500.00, ARRAY[ 5, 6]);
CALL add_service_and_map_to_rooms('external', 'Personal Shopper', 1, 150.00, ARRAY[ 3, 5, 6, 7]);
CALL add_service_and_map_to_rooms('damage', 'Smoking Penalty Fee', 1, 250.00, ARRAY[ 1, 2, 3, 4, 5, 6, 7, 8]);
CALL add_service_and_map_to_rooms('damage', 'Pet Cleaning Fee', 1, 100.00, ARRAY[1, 2, 3, 4, 5, 6, 7, 8]);


/* Triggers */

-- Trigger 1: Suggest Packages for Room
create or replace function suggest_packages_for_room()
    returns trigger as $$
    declare
        suggested_packages record;
    begin
        for suggested_packages
            in select p.id, p.name
               from packages p
               where p.room_category = new.room_category
            loop
            raise notice 'Package Suggestion for Room Category %: [%] %',
                new.room_category,
                suggested_packages.id,
                suggested_packages.name;
            end loop;
        return new;
        end;
    $$ language plpgsql;
create trigger trigger_suggest_packages_for_room
    after insert or update of room_category on reservations
    for each row
    execute function suggest_packages_for_room();

-- Trigger 2: Handle Reservation Cancellation
create or replace function handle_completed_reservation_cancellation()
    returns trigger as $$
    begin
        if old.status = 'completed' and new.status = 'cancelled' then
            update rooms set status = 'available' where id = new.room_id;
            update reservations set subtotal = 0 where id = new.id;
            raise notice 'Reservation ID %, previously completed, has been cancelled and the room is now available.', new.id;
            end if;
        return new;
        end;
    $$ language plpgsql;
create trigger trigger_handle_completed_reservation_cancellation
    after update of status on reservations
    for each row
    when (old.status = 'completed' and new.status = 'cancelled')
    execute function handle_completed_reservation_cancellation();

-- Trigger 3: Update Reservation Subtotal
create or replace function update_reservation_package()
    returns trigger as $$
    declare
        packagePrice decimal(10, 2);
    begin
        if not exists (select 1 from packages where id = new.package and room_category = new.room_category) then
            raise exception 'Selected package is not valid for the room category.';
            end if;
        select coalesce(sum(rs.price), 0) into packagePrice
                                          from package_mapping pm
                                              join room_services rs on pm.room_service_id = rs.id
                                          where pm.package_id = new.package;
        new.subtotal := packagePrice + (select price from room_categories where id = new.room_category);
        raise notice 'Reservation subtotal updated to $%.', new.subtotal;
        return new;
        end;
    $$ language plpgsql;
create trigger trigger_update_reservation_package
    before update of package on reservations
    for each row
    execute function update_reservation_package();

-- Trigger 4: Update Reservation Subtotal
create or replace function audit_front_desk_agents()
    returns trigger as $$
    declare
        stayDuration int;
        bonusAmount decimal(10, 2);
    begin
        stayDuration := new.check_out - new.check_in;
        if stayDuration >= 10 then
            bonusAmount := 1500.00;
        elsif stayDuration >= 5 then
            bonusAmount := 500.00;
        elsif stayDuration >= 3 then
            bonusAmount := 380.00;
        else
            bonusAmount := 0.00;
        end if;
        insert into audits (agent_id, guest_id, check_in_date, check_out_date, bonus)
        values (new.agent_id, new.guest_id, new.check_in, new.check_out, bonusAmount);
        return new;
    end;
    $$ language plpgsql;
create trigger trigger_audit_front_desk_agents
    after insert or update on reservations
    for each row
    execute function audit_front_desk_agents();

-- Trigger 5: Update Reservation Subtotal
create or replace function services_validation()
    returns trigger as $$
    begin
        if tg_op = 'insert' then
            if new.type not in ('internal', 'external') then
                raise exception 'Service type must be either "internal" or "external".';
            end if;
        elsif tg_op = 'update' then
            if new.price < 0 then
                raise exception 'Service price cannot be negative.';
            end if;
        elsif tg_op = 'delete' then
            if exists (select 1 from room_services where service_id = old.id) then
                raise exception 'Cannot delete service that is associated with a room.';
            end if;
        end if;
        return new;
    end;
    $$ language plpgsql;
create trigger trigger_services_validation
    before insert or update or delete on services
    for each row
    execute function services_validation();


/* Stored procedures */

-- Procedure 1: Add a new room category
create or replace function add_new_package(
    packageName varchar(255),
    packageStartDate date,
    packageEndDate date,
    packageRoomCategoryId int,
    packageDescription text,
    packageDiscount int,
    roomServiceIds int[]
) returns void as $$
    declare
        newPackageId int;
        serviceId int;
    begin
        insert into packages (name, start_date, end_date, room_category, description, discount)
        values (packageName, packageStartDate, packageEndDate, packageRoomCategoryId, packageDescription, packageDiscount)
        returning id into newPackageId;
        foreach serviceId in array roomServiceIds loop
            if exists (select 1 from room_services where id = serviceId and room_id = packageRoomCategoryId) then
                insert into package_mapping (package_id, room_service_id)
                values (newPackageId, serviceId);
            else
                raise exception 'Service with ID % is not available for the room category ID %.',
                    serviceId, packageRoomCategoryId;
            end if;
        end loop;
    end;
    $$ language plpgsql;

-- Procedure 2: Add a new service and map it to rooms
create or replace procedure add_service_and_map_to_rooms(
    serviceType varchar(255),
    serviceName varchar(255),
    deptId int,
    basePrice decimal(10, 2),
    eligibleRoomCategories int[]
) language plpgsql as $$
    declare
        newServiceId int;
        roomCat record;
        adjustedPrice decimal(10, 2);
    begin
        insert into services (type, name, department, price)
        values (serviceType, serviceName, deptId, basePrice)
        returning id into newServiceId;
    for roomCat in select id, name from room_categories loop
        if roomCat.id = any(eligibleRoomCategories) then
            if roomCat.name = 'Deluxe' then
                adjustedPrice := basePrice * 1.3;
			elseif roomCat.name = 'Suite' then
                adjustedPrice := basePrice * 1.4;
			elsif roomCat.name = 'Presidential Suite' then
				adjustedPrice := basePrice * 1.7;
			elsif roomCat.name = 'Family' then
				adjustedPrice := basePrice * 1.2;
            else
                adjustedPrice := basePrice;
            end if;
            insert into room_services (room_id, service_id, price)
            values (roomCat.id, newServiceId, adjustedPrice);
        end if;
    end loop;
end;
$$;

-- Procedure 3: Check in a guest
create or replace function check_in_guest(reservation_id int, guest_id int)
    returns void as $$
    declare
        assigned_room int;
        room_status varchar(255);
    begin
        select room_id into assigned_room
                       from reservations
                       where id = reservation_id
                         and guest_id = guest_id
                         and status = 'pending';
        if not found then
            raise exception 'Reservation not found or not in pending status.';
        end if;
        select status into room_status
                      from rooms
                      where id = assigned_room;
        if room_status <> 'available' then
            raise exception 'Assigned room is not available.';
        end if;
        update reservations set status = 'in progress',
                                check_in = current_date
                            where id = reservation_id;
        update rooms set status = 'occupied'
                     where id = assigned_room;
    end;
    $$ language plpgsql;

-- Procedure 4: Check out a guest
create or replace function check_out_guest(reservation_id int)
    returns void as $$
    declare
        assigned_room_id int;
    begin
        select room_id, subtotal
        into assigned_room_id
        from reservations
        where id = reservation_id;
        select sum(subtotal)
        into total_service_charges
        from consumptions
        where reservation_id = reservation_id;
        final_bill_amount := total_room_charges + coalesce(total_service_charges, 0);
        update reservations set status = 'completed',
                                check_out = current_date
                            where id = reservation_id;
        update rooms set status = 'available'
                     where id = assigned_room_id;
        insert into final_bills (reservation_id, total_amount)
        values (reservation_id, final_bill_amount);
        raise notice 'Guest from reservation % has checked out. Final bill amount: %',
            reservation_id, final_bill_amount;
    end;
    $$ language plpgsql;

-- Procedure 5: Check room availability
create or replace function check_room_availability(optional_category_id int default null)
    returns table(room_id int,
                  room_number int,
                  category_name varchar,
                  capacity int) as $$
    begin
        return query
            select r.id, r.number, rc.name, rc.capacity
            from rooms r
                inner join room_categories rc on r.category_id = rc.id
            where r.status = 'available'
              and (optional_category_id is null
                       or r.category_id = optional_category_id);
    end;
    $$ language plpgsql;


/* Queries */

set search_path to hotel_california;

-- Query 1: Invoice for Hotel Stay Services
select
    g.first_name || ' ' || g.last_name as "Guest Name",
    r.id as "Reservation ID",
    r.check_in as "Check-in",
    r.check_out as "Check-out",
    sum(c.subtotal) as "Total Charge",
    array_agg(s.name) as "Services Used"
from reservations r
    join guests g on r.guest_id = g.id
    join consumptions c on c.reservation_id = r.id
    join services s on s.id = c.service_id
group by g.first_name, g.last_name, r.id, r.check_in, r.check_out;

-- Query 2: Report of Available Rooms by Room Type
select
    rc.name as "Room Category",
    count(r.id) as "Available Rooms Count"
from rooms r
    join room_categories rc on r.category_id = rc.id
where r.status = 'available'
group by rc.name;

-- Query 3: Report of Occupied Rooms and Guest Count by Date
select
    r.number as "Room Number",
    count(g.id) + count(c.id) as "Number of Guests"
from rooms r
    left join reservations res on r.id = res.room_id
                                      and res.status = 'in progress'
    left join guests g on res.guest_id = g.id
    left join companions c on g.id = c.guest_id
where current_date between res.check_in and res.check_out
group by r.number;

-- Query 4: Seasonal Report of Occupancy
with seasons as (
    select 'High Season' as season, '2023-01-01' as start, '2023-03-31' as finish
    union select 'Low Season' as season, '2023-04-01' as start, '2023-06-30' as finish
) select
      T.season,
      count(*) as total_reservas,
      sum(case when R.status = 'completed' then 1 else 0 end) as reservas_completadas,
      sum(case when R.status = 'cancelled' then 1 else 0 end) as reservas_canceladas,
      sum(case when R.status = 'in progress' then 1 else 0 end) as reservas_en_progreso,
      sum(case when R.status = 'expired' then 1 else 0 end) as reservas_expiradas
  from seasons T
      join reservations R on R.check_in
          between T.start and T.finish
  where R.check_in between '2023-01-01' and '2023-12-31'
  group by T.season;

-- Query 5: Report of Room Types with Descriptions and Availability:
select
    rc.name as "Room Type",
    rc.description,
    count(r.id) filter (where r.status = 'available') as "Available",
    count(r.id) filter (where r.status = 'occupied') as "Occupied"
from room_categories rc
    left join rooms r on rc.id = r.category_id
group by rc.name, rc.description;

-- Query 6: Report of Longest Occupancy Records
select
    g.first_name || ' ' || g.last_name as "Guest Name",
    r.id as "Reservation ID",
    r.check_in as "Check-in",
    r.check_out as "Check-out",
    (r.check_out - r.check_in) as "Length of Stay"
from reservations r
    join guests g on r.guest_id = g.id
order by "Length of Stay" desc limit 1;

-- Query 7: Report of Employee Bonuses
select
    a.first_name || ' ' || a.last_name as "Agent Name",
    sum(aud.bonus) as "Total Bonus"
from agents a
    join audits aud on a.id = aud.agent_id
group by a.first_name, a.last_name;

-- Query 8: Report of Highest Bonus Reception Agents
select
    a.first_name || ' ' || a.last_name as "Agent Name",
    sum(aud.bonus) as "Total Bonus"
from agents a
    join audits aud on a.id = aud.agent_id
where a.department = (select id from departments where name = 'Reception')
  and aud.check_in_date > '2025-10-01' and aud.check_out_date < '2026-01-01'
group by a.first_name, a.last_name
order by "Total Bonus" desc limit 1;

-- Query 9: Revenue Report from Services and Packages
select
    'Service Revenue' as "Type",
    sum(c.subtotal) as "Total"
from consumptions c
where c.date between '2023-06-01' and '2023-12-31'
union select
    'Package Revenue' as "Type",
    sum(p_s.price) as "Total"
from packages p
    join reservations r on p.id = r.package
    join room_services p_s on p_s.room_id = r.room_id;

-- Query 10: Report of Feedback by Satisfaction Rating
select
    d.name as "Department Name",
    avg(f.rating) as "Average Rating"
from feedback f
    join departments d on f.department = d.id
group by d.name;

-- Query 11: Report of Complaints Registered Based on Date Range and Classification:
select
    f.issue_type as "Complaint Type",
    count(f.id) as "Number of Complaints",
    to_char(f.date, 'YYYY-MM-DD') as "Date"
from feedback f
where f.issue_type = 'Complaint'
  and f.date between 'Start_Date' and 'End_Date'
group by f.issue_type, to_char(f.date, 'YYYY-MM-DD');

-- Query 12: Report of Guest Registrations by Registration Method
select
    g.registration_method as "Registration Method",
    count(g.id) as "Number of Guests",
    sum(r.subtotal) as "Total Revenue"
from guests g
    join reservations r on g.id = r.guest_id
where r.check_in between 'Start_Date' and 'End_Date'
group by g.registration_method;

-- Query 13: Report of the Department with the Best Satisfaction Rating
select
    d.name as "Department Name",
    avg(f.rating) as "Average Satisfaction Rating"
from feedback f
    join departments d on f.department = d.id
where f.date between '2023-02-01' and '2023-02-14'
group by d.name
order by "Average Satisfaction Rating" desc limit 1;


/* User creation */

set search_path to hotel_california;

create role front_desk;
grant connect on database hotel_california to front_desk;
grant select, insert, update on guests, reservations, companions to front_desk;
grant select on rooms, services to front_desk;

create role housekeeping;
grant connect on database hotel_california to housekeeping;
grant select, update on rooms to housekeeping;

create role accounting;
grant connect on database hotel_california to accounting;
grant select on reservations, audits, final_bills to accounting;

create role management;
grant connect on database hotel_california to management;
grant select on all tables in schema hotel_california to management;

create user accountant1 with password '1234';
create user front_desk1 with password '2345';
create user housekeeping1 with password '3456';
create user management1 with password '4567';

grant front_desk to front_desk1;
grant accountant to accountant1;
grant housekeeping to housekeeping1;
grant management to management1;