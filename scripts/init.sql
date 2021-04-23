declare @w_id_rol int,
		@w_rol_descripcion varchar(200)

select @w_rol_descripcion = 'CAP SEMILLERO4'

if exists(select 1 from ad_rol where ro_descripcion = @w_rol_descripcion)
begin
	delete from ad_rol where ro_descripcion = @w_rol_descripcion
end

select @w_id_rol = max(ro_rol) from ad_rol

select @w_id_rol = @w_id_rol + 1

INSERT INTO dbo.ad_rol (ro_rol, ro_filial, ro_descripcion, ro_fecha_crea, ro_creador, ro_estado, ro_fecha_ult_mod, ro_time_out, ro_admin_seg, ro_departamento, ro_oficina)
VALUES (@w_id_rol, 1, @w_rol_descripcion, getdate(), 3, 'V', getdate(), 900, NULL, NULL, NULL)

select * from ad_rol where ro_rol = @w_id_rol



--PROCEDIENTO PARA AÑADIR MENU
IF OBJECT_ID ('sp_menus_semillero') IS NOT NULL
	DROP PROCEDURE sp_menus_semillero
GO

create procedure sp_menus_semillero
   @i_id_url 					varchar(500),
   @i_id_parent				   	int,
   @i_name	   	    			varchar(100),
   @i_description				varchar(100),
   @i_operacion					char(1)

as
declare
   @w_id_menu			int,
   @w_id_producto		int,
   @w_id_rol	   		int

if @i_operacion = 'I'
begin
	
end
	--Verifica si existe el menu con la url ingresada
	if exists(select 1 from cew_menu where me_url = @i_id_url)
	begin
		delete from cew_menu where me_url = @i_id_url
	end
	
	--Suma 1 al ultimo menu insertado
	select @w_id_menu = max(me_id) from cew_menu
	select @w_id_menu = @w_id_menu + 1
	
	--Busca el id del producto
	select @w_id_producto = pd_producto from cl_producto where pd_descripcion = 'CLIENTES'
	
	--Inserta el menu
	insert into dbo.cew_menu 
	(me_id, 		me_id_parent, me_name, me_visible, me_url, me_order,
	me_id_cobis_product, me_option, me_description, me_version, me_container)
	values 
	(@w_id_menu, 	@i_id_parent, @i_name, 			1, @i_id_url, 		1,
	@w_id_producto, 			 0, @i_description, 	  NULL, 	   'CWC')
	
	--Busca el id del rol CAP SEMILLERO4
	select @w_id_rol =  ro_rol from ad_rol where ro_descripcion = 'CAP SEMILLERO4'
	
	--Si esta registrado en la tabla de asignacion de rol, se elimina
	if exists(select 1 from cew_menu_role where mro_id_menu = @w_id_menu and mro_id_role=@w_id_rol)
	begin
		delete from cew_menu where me_url = @i_id_url
	end
	
	--Se relaciona el menu con el rol
	insert into cew_menu_role (mro_id_menu, mro_id_role)
	values (@w_id_menu, @w_id_rol)
go

-- MENU PRINCIPAL
declare @w_id_menu 		int,
		@w_id_producto	int,
		@w_id_url		varchar(300),
		@w_id_rol		int,
		@w_me_name		varchar(100)

select @w_me_name = 'MNU_FASE4'

if exists(select 1 from cew_menu where me_name = @w_me_name)
begin
	delete from cew_menu where me_name = @w_me_name
end

select @w_id_menu = max(me_id) from cew_menu

select @w_id_menu = @w_id_menu + 1

select @w_id_producto = pd_producto from cl_producto where pd_descripcion = 'CLIENTES'

insert into dbo.cew_menu
(me_id, me_id_parent, me_name, me_visible, me_url, me_order, 
me_id_cobis_product, me_option, me_description, me_version, me_container)
values 
(@w_id_menu, 	null, @w_me_name, 		1, 	 null, 		1, 
@w_id_producto, 			0,   'Menu FASE 4', 	  null, 	   'CWC')

select @w_id_rol =  ro_rol from ad_rol where ro_descripcion = 'CAP SEMILLERO4'

if exists(select 1 from cew_menu_role where mro_id_menu = @w_id_menu and mro_id_role=@w_id_rol)
begin
	delete from cew_menu where me_url = @w_id_url
end

insert into cew_menu_role (mro_id_menu, mro_id_role)
values (@w_id_menu, @w_id_rol)

select * from cew_menu where me_name = @w_me_name

select * from cew_menu_role where mro_id_menu = @w_id_menu



---------------------------------Añadir el resto de menus ------------------------------------------
declare @w_id_menu int
select @w_id_menu = me_id from cew_menu where me_name = 'MNU_FASE4'
exec sp_menus_semillero 
	@i_url 							= 'views/FRONT/ENDDD/T_FRONTRPGDCKMI_937/1.0.0/VC_ESTUDIANVV_112937_TASK.html', 
	@i_id_parent 					= @w_id_menu, 
	@i_name 						= 'MNU_ESTUDIANTEVPI', 
	@i_description 					= 'Menu EstudianteVPI del grupo 1', 
	@i_operacion					='I'
go

declare @w_id_menu int
select @w_id_menu = me_id from cew_menu where me_name = 'MNU_FASE4'
exec sp_menus_semillero 
	@i_url 							= 'views/FRONT/ENDDD/T_FRONTUVXMNZNU_590/1.0.0/VC_ESTUDIANFA_171590_TASK.html', 
	@i_id_parent 					= @w_id_menu, 
	@i_name 						= 'MNU_ESTUDIANTEAFCL', 
	@i_description 					= 'Menu EstudianteAFCL del grupo 1', 
	@i_operacion					='I'
go

declare @w_id_menu int
select @w_id_menu = me_id from cew_menu where me_name = 'MNU_FASE4'
exec sp_menus_semillero 
	@i_url 							= 'views/FRONT/ENDDD/T_FRONTWTSVCGKR_940/1.0.0/VC_ESTUDIANTE_758940_TASK.html',
	@i_id_parent 					= @w_id_menu, 
	@i_name 						= 'MNU_ESTUDIANTEMAPL', 
	@i_description 					= 'Menu EstudianteMAPL del grupo 1', 
	@i_operacion					='I'
go

declare @w_id_menu int
select @w_id_menu = me_id from cew_menu where me_name = 'MNU_FASE4'
exec sp_menus_semillero 
	@i_url 							= 'views/FRONT/ENDDD/T_FRONTKFXUJXAZ_402/1.0.0/VC_ESTUDIANEA_712402_TASK.html', 
	@i_id_parent 					= @w_id_menu, 
	@i_name 						= 'MNU_ESTUDIANTEARC', 
	@i_description 					= 'Menu EstudianteARC del grupo 1', 
	@i_operacion					='I'
go