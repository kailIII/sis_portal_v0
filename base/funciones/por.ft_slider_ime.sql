CREATE OR REPLACE FUNCTION "por"."ft_slider_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		PORTAL
 FUNCION: 		por.ft_slider_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'por.tslider'
 AUTOR: 		 (admin)
 FECHA:	        18-09-2015 13:41:35
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:	
 AUTOR:			
 FECHA:		
***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_slider	integer;
			    
BEGIN

    v_nombre_funcion = 'por.ft_slider_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'POR_SLID_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		18-09-2015 13:41:35
	***********************************/

	if(p_transaccion='POR_SLID_INS')then
					
        begin

					--FAVIO
        	--Sentencia de la insercion
        	insert into por.tslider(
			extension,
			estado_reg,
			url_original,
			estado,
			descripcion,
			orden,
			nombre_archivo,
			titulo,
			id_usuario_reg,
			fecha_reg,
			usuario_ai,
			id_usuario_ai,
			id_usuario_mod,
			fecha_mod
          	) values(
			v_parametros.extension,
			'activo',
			v_parametros.folder,
			'activo',
			v_parametros.descripcion,
			v_parametros.orden,
			v_parametros.nombre_archivo,
			v_parametros.titulo,
			p_id_usuario,
			now(),
			v_parametros._nombre_usuario_ai,
			v_parametros._id_usuario_ai,
			null,
			null
							
			
			
			)RETURNING id_slider into v_id_slider;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','slider almacenado(a) con exito (id_slider'||v_id_slider||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_slider',v_id_slider::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'POR_SLID_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		18-09-2015 13:41:35
	***********************************/

	elsif(p_transaccion='POR_SLID_MOD')then

		begin
			--Sentencia de la modificacion
			update por.tslider set
			extension = v_parametros.extension,
			url_pequeno = v_parametros.url_pequeno,
			url_original = v_parametros.url_original,
			estado = v_parametros.estado,
			url_mediano = v_parametros.url_mediano,
			descripcion = v_parametros.descripcion,
			orden = v_parametros.orden,
			nombre_archivo = v_parametros.nombre_archivo,
			titulo = v_parametros.titulo,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_slider=v_parametros.id_slider;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','slider modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_slider',v_parametros.id_slider::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'POR_SLID_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		18-09-2015 13:41:35
	***********************************/

	elsif(p_transaccion='POR_SLID_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from por.tslider
            where id_slider=v_parametros.id_slider;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','slider eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_slider',v_parametros.id_slider::varchar);
              
            --Devuelve la respuesta
            return v_resp;

		end;
         
	else
     
    	raise exception 'Transaccion inexistente: %',p_transaccion;

	end if;

EXCEPTION
				
	WHEN OTHERS THEN
		v_resp='';
		v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
		v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
		v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
		raise exception '%',v_resp;
				        
END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE
COST 100;
ALTER FUNCTION "por"."ft_slider_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
    