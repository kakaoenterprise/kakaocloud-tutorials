
drop table if exists book;
drop table if exists category;
drop table if exists status;
drop table if exists book_Cover;

create table if not exists category(
    id   varchar(10),
    name varchar(50) not null
);

create table if not exists status(
    status varchar(5)
);

create table if not exists book (
    book_Id      VARCHAR(30) primary key,
    name        VARCHAR(100),
    publish_Date DATE,
    company     VARCHAR(100),
    writer      VARCHAR(100),
    status      VARCHAR(20),
    quantity    INT,
    category    VARCHAR(50),
    recommended BOOLEAN,
    image_url   VARCHAR(1000)
);
