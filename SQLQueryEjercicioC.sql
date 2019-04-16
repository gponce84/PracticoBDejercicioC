create database tiendas

use tiendas

create table tienda1(
id int not null identity(1,1),
tienda varchar(50),
nombre_producto varchar(50),
cantidad int
)

create table tienda2(
id int not null identity(1,1),
tienda varchar(50),
nombre_producto varchar(50),
cantidad int
)

create table tienda3(
id int not null identity(1,1),
tienda varchar (50),
nombre_producto varchar(50),
cantidad int
)

create table auditoria(
id int not null identity(1,1),
usuario varchar(50),
tabla varchar (50),
fecha datetime,
accion varchar(10),
filas_afectadas int
)
-----
CREATE TRIGGER tr_auditoria_inserted
ON tienda1  FOR INSERT 	AS
	BEGIN
		declare @cant int;
		SELECT @cant = COUNT(*) FROM inserted
		insert into auditoria (usuario, tabla,fecha,accion,filas_afectadas)
		select SYSTEM_USER,inserted.tienda,getdate(),'I', @cant
		from inserted
	END


insert into  tienda1( tienda,nombre_producto,cantidad)
values ('Tienda1', 'teclados',8)
----------------------------
alter   TRIGGER tr_auditoria_delete
ON tienda1  FOR delete 	AS
	BEGIN
		declare @cant int;
		SELECT @cant = COUNT(*) FROM deleted
		insert into auditoria (usuario, tabla,fecha,accion,filas_afectadas)
		select SYSTEM_USER,d.tienda,getdate(),'D', @cant
		from deleted d
	END

delete  from tienda1 where id = 2
------------------------------------------
CREATE   TRIGGER tr_auditoria_Update
ON tienda1  FOR update 	AS
	BEGIN
		declare @cant int;
		SELECT @cant = COUNT(*) FROM inserted
		insert into auditoria (usuario, tabla,fecha,accion,filas_afectadas)
		select SYSTEM_USER,i.tienda,getdate(),'U', @cant
		from inserted i
	END

update tienda1 set cantidad = 8 where id = 1

select * from tienda1
select * from auditoria
---------------------------------------------------
ALTER  TRIGGER tr_auditoria_Update
ON tienda1  FOR INSERT, UPDATE, DELETE 	AS
	BEGIN
		declare @cantI int;
		declare @cantD int;
		declare @cant int;
		DECLARE @tipo varchar(10);
		SELECT @cantI = COUNT(*) FROM inserted
		SELECT @cantD = COUNT(*) FROM deleted
		if( @cantI >  @cantD)
		begin
		 set @tipo = 'I';
		SELECT @cant = COUNT(*) FROM inserted
		end
		if( @cantI <  @cantD)
		begin
			set @tipo = 'D';
			SELECT @cant = COUNT(*) FROM deleted
		end
		if( @cantI = @cantD)
		begin
			set @tipo = 'U';
			SELECT @cant = COUNT(*) FROM inserted
		end
		insert into auditoria (usuario, tabla,fecha,accion,filas_afectadas)
		select SYSTEM_USER,i.tienda,getdate(),@tipo, @cant
		from inserted i
	END

select *  from auditoria
truncate table auditoria


insert into  tienda1( tienda,nombre_producto,cantidad)
values ('Tienda1', 'teclados',8)

update tienda1 set cantidad = 8 where id = 1

delete  from tienda1 where id = 2