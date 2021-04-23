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

go


--PROCEDIENTO PARA AÑADIR MENU
IF OBJECT_ID ('sp_menus_semillero') IS NOT NULL
	DROP PROCEDURE sp_menus_semillero
GO

create procedure sp_menus_semillero
   @i_url 						varchar(500) 	= null,
   @i_id_parent				   	int				= null,
   @i_name	   	    			varchar(100)	= null,
   @i_description				varchar(100)	= null,
   @i_operacion					char(1)

as
declare
   @w_id_menu			int,
   @w_id_producto		int,
   @w_id_rol	   		int

if @i_operacion = 'I'
begin
	--Verifica si existe el menu con la url ingresada
	if exists(select 1 from cew_menu where me_url = @i_url )
	begin
		set @w_id_menu = (select me_id from cew_menu where me_url=@i_url )
        delete from cew_menu_role where mro_id_menu = @w_id_menu
        delete from cew_menu where me_url=@i_url
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
	(@w_id_menu, 	@i_id_parent, @i_name, 			1, @i_url , 		1,
	@w_id_producto, 			 0, @i_description, 	  NULL, 	   'CWC')
	
	--Busca el id del rol CAP SEMILLERO4
	select @w_id_rol =  ro_rol from ad_rol where ro_descripcion = 'CAP SEMILLERO4'
	
	--Se relaciona el menu con el rol
	insert into cew_menu_role (mro_id_menu, mro_id_role)
	values (@w_id_menu, @w_id_rol)
end
go



-- MENU PRINCIPAL
declare @w_id_menu 		int,
		@w_id_producto	int,
		@w_url			varchar(300),
		@w_id_rol		int,
		@w_me_name		varchar(100)

select @w_me_name = 'MNU_FASE4'

if exists(select 1 from cew_menu where me_name = @w_me_name)
begin
	select @w_id_menu = me_id from cew_menu where me_name = @w_me_name
	delete crol from cew_menu_role crol, cew_menu cmenu where crol.mro_id_menu = cmenu.me_id and cmenu.me_id_parent = @w_id_menu
	delete from cew_menu where me_id_parent = @w_id_menu
	delete from cew_menu_role where mro_id_menu = @w_id_menu
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

insert into cew_menu_role (mro_id_menu, mro_id_role)
values (@w_id_menu, @w_id_rol)

select * from cew_menu where me_name = @w_me_name

select * from cew_menu_role where mro_id_menu = @w_id_menu

go




---------------------------------Añadir el resto de menus ------------------------------------------
declare @w_id_menu int
select @w_id_menu = me_id from cew_menu where me_name = 'MNU_FASE4'
exec sp_menus_semillero 
	@i_url 							= 'views/FRONT/ENDDD/T_FRONTJXBJZVQW_794/1.0.0/VC_ESTUDIANMD_132794_TASK.html', 
	@i_id_parent 					= @w_id_menu, 
	@i_name 						= 'MNU_ESTUDIANTEDMP', 
	@i_description 					= 'Menu EstudianteDmp del grupo 3', 
	@i_operacion					='I'
go

declare @w_id_menu int
select @w_id_menu = me_id from cew_menu where me_name = 'MNU_FASE4'
exec sp_menus_semillero 
	@i_url 							= 'views/FRONT/ENDDD/T_FRONTYFEACMSI_996/1.0.0/VC_ESTUDIANDY_850996_TASK.html', 
	@i_id_parent 					= @w_id_menu, 
	@i_name 						= 'MNU_ESTUDIANTEDSY', 
	@i_description 					= 'Menu EstudianteDsy del grupo 3', 
	@i_operacion					='I'
go

declare @w_id_menu int
select @w_id_menu = me_id from cew_menu where me_name = 'MNU_FASE4'
exec sp_menus_semillero 
	@i_url 							= 'views/FRONT/ENDDD/T_FRONTCZCRNJKD_109/1.0.0/VC_ESTUDIANSS_585109_TASK.html', 
	@i_id_parent 					= @w_id_menu, 
	@i_name 						= 'MNU_ESTUDIANTEASH', 
	@i_description 					= 'Menu EstudianteAsh del grupo 3', 
	@i_operacion					='I'
go

declare @w_id_menu int
select @w_id_menu = me_id from cew_menu where me_name = 'MNU_FASE4'
exec sp_menus_semillero 
	@i_url 							= 'views/FRONT/ENDDD/T_FRONTGLOZBOPH_997/1.0.0/VC_ESTUDIANTT_344997_TASK.html', 
	@i_id_parent 					= @w_id_menu, 
	@i_name 						= 'MNU_ESTUDIANTEJCO', 
	@i_description 					= 'Menu EstudianteJco del grupo 3', 
	@i_operacion					='I'
go

--Grupo 2
declare @w_id_menu int
select @w_id_menu = me_id from cew_menu where me_name = 'MNU_FASE4'
exec sp_menus_semillero 
	@i_url 							= 'views/FRONT/ENDDD/T_FRONTHDPRWEIY_200/1.0.0/VC_ESTUDIANTE_738200_TASK.html', 
	@i_id_parent 					= @w_id_menu, 
	@i_name 						= 'MNU_ESTUDIANTEBDF', 
	@i_description 					= 'Menu EstudianteBDF del grupo 2', 
	@i_operacion					='I'
go

declare @w_id_menu int
select @w_id_menu = me_id from cew_menu where me_name = 'MNU_FASE4'
exec sp_menus_semillero 
	@i_url 							= 'views/FRONT/ENDDD/T_FRONTYYLHVRWX_877/1.0.0/VC_ESTUDIANZZ_362877_TASK.html', 
	@i_id_parent 					= @w_id_menu, 
	@i_name 						= 'MNU_ESTUDIANTEDGZ', 
	@i_description 					= 'Menu EstudianteDGZ del grupo 2', 
	@i_operacion					='I'
go

declare @w_id_menu int
select @w_id_menu = me_id from cew_menu where me_name = 'MNU_FASE4'
exec sp_menus_semillero 
	@i_url 							= 'views/FRONT/ENDDD/T_FRONTFSTIYXEX_288/1.0.0/VC_ESTUDIANEJ_444288_TASK.html', 
	@i_id_parent 					= @w_id_menu, 
	@i_name 						= 'MNU_ESTUDIANTEJES', 
	@i_description 					= 'Menu EstudianteJES del grupo 2', 
	@i_operacion					='I'
go

declare @w_id_menu int
select @w_id_menu = me_id from cew_menu where me_name = 'MNU_FASE4'
exec sp_menus_semillero 
	@i_url 							= 'views/FRONT/ENDDD/T_FRONTNUITXMNA_708/1.0.0/VC_ESTUDIANME_123708_TASK.html', 
	@i_id_parent 					= @w_id_menu, 
	@i_name 						= 'MNU_ESTUDIANTELAM', 
	@i_description 					= 'Menu EstudianteLAM del grupo 2', 
	@i_operacion					='I'
go

declare @w_id_menu int
select @w_id_menu = me_id from cew_menu where me_name = 'MNU_FASE4'
exec sp_menus_semillero 
	@i_url 							= 'views/FRONT/ENDDD/T_FRONTWTSVCGKR_940/1.0.0/VC_ESTUDIANTE_758940_TASK.html', 
	@i_id_parent 					= @w_id_menu, 
	@i_name 						= 'MNU_ESTUDIANTEOFV', 
	@i_description 					= 'Menu EstudianteOFV del grupo 2', 
	@i_operacion					='I'
go

-- grupo1