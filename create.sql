create database bookstore
go

use bookstore
create table DBUSER
(
    Username VARCHAR(30) not null,
    Password VARCHAR(30) not null,
    primary key(Username)
)

CREATE TABLE BSUSER
(
    Username VARCHAR(15) NOT NULL,
    Password VARCHAR(15) NOT NULL,
    Address VARCHAR(20) NOT NULL,
    PRIMARY KEY(Username)
);

CREATE TABLE AUTHOR
(
    AuthorID VARCHAR(15) NOT NULL,
    AuthorName VARCHAR(15) NOT NULL,
    PRIMARY KEY(AuthorID)
);

CREATE TABLE BOOK
(
    ISBN CHAR(14) NOT NULL,
    Title VARCHAR(50) NOT NULL,
    AuthorID VARCHAR(15) NOT NULL,
    Quantity INT NOT NULL,
    CHECK (Quantity >= 0),
    PRIMARY KEY(ISBN),
    FOREIGN KEY(AuthorID) references AUTHOR(AuthorID)
);

CREATE TABLE REVIEW
(
    Reviewer VARCHAR(15) NOT NULL,
    BookID CHAR(14) NOT NULL,
    Rating INT NOT NULL,
    Review TEXT,
    CHECK (Rating >= 1 OR Rating <= 5),
    PRIMARY KEY(Reviewer, BookID),
    FOREIGN KEY(Reviewer) references BSUSER(Username),
    FOREIGN KEY(BookID) references BOOK(ISBN)
);

CREATE TABLE TRANSACT
(
    Buyer VARCHAR(15) NOT NULL,
    BookID CHAR(14) NOT NULL,
    DateTime CHAR(23) NOT NULL,
    PRIMARY KEY(Buyer, BookID, DateTime),
    FOREIGN KEY(Buyer) references BSUSER(Username),
    FOREIGN KEY(BookID) references BOOK(ISBN)
);

create table BOOKMARK
(
    Title VARCHAR(15),
    Owner VARCHAR(15),
    BookID CHAR(14),
    Owned Bit,
    primary key(Title, Owner, BookID),
    foreign key(Owner) references BSUSER(Username),
    foreign key(BookID) references BOOK(ISBN)
)
go

create trigger t_reivew on REVIEW for insert as
if (select count(*)
    from TRANSACT t, inserted i
    where t.Buyer=i.Reviewer and t.BookID=i.BookID)=0
begin
rollback TRANSACTION
end
go

create trigger t_transact on TRANSACT for insert as
update book set quantity=quantity-1 where ISBN=(select BookID from inserted)
update bookmark set Owned=1 where BookID = (select BookID from inserted)
and Owner=(select Buyer from inserted)