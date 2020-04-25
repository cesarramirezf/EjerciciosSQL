-----------------------------------Ejercicios del curso Profesional de Base de Datos, codigofacilito-----------------
--------------------------------Primera Parte------------------------------------
--------------------------------Libros-------------
Select titulo from libros where autor_id IN( Select autor_id from autores where seudonimo is not null);

Select titulo from libros where autor_id IN( Select autor_id from autores where seudonimo is not NULL) and year(fecha_publicacion) = year(@now);

Select titulo from libros where autor_id IN( Select autor_id from autores where seudonimo is not NULL AND year(fecha_nacimiento) < 1965);

UPDATE libros SET descripcion ='No Disponible' where year(fecha_publicacion) < 2000;

Select autor_id from libros where descripcion != 'No Disponible';

Select titulo from libros where autor_id = 2 ORDER BY fecha_publicacion DESC limit 3;

SELECT COUNT(libro_id) As Con_Seudonimo, "" as Sin_Seudonimo FROM Libros where autor_id IN( SELECT autor_id from autores where seudonimo is not NULL)
UNION
SELECT " ", COUNT(libro_id) As Sin_Seudonimo FROM Libros where autor_id IN( SELECT autor_id from autores where seudonimo is NULL);

Select COUNT(libro_id) from libros where fecha_publicacion > 2000-01-01 and year(fecha_publicacion) <= 2005-01-31;

Select titulo, ventas from libros order by ventas desc limit 5;

Select titulo, ventas from libros where year(fecha_publicacion)>2010 and year(fecha_publicacion)<2020 order by ventas desc limit 5;

SELECT autor_id, sum(ventas) from libros group by autor_id order by autor_id limit 3;

Select titulo from libros where paginas = (SELECT max(paginas) from libros);

Select titulo from libros where titulo LIKE 'LA%';

Select titulo from libros where titulo LIKE 'LA%' and titulo like '%A';

UPDATE libros SET stock = 0 where year(fecha_publicacion) < 1995;

Select titulo from libros ORDER BY fecha_publicacion desc;
---------------------------Autores--------------------------
select nombre from autores where year(fecha_nacimiento) > 1950;

SELECT CONCAT(nombre, ' ', apellido) as nombre_Completo, 2020 - year(fecha_nacimiento) As edad from autores;

SELECT CONCAT(nombre, ' ', apellido) from autores where autor_id IN(select autor_id from libros where year(fecha_publicacion) > 2005);

Select autor_id from libros where ventas > (Select avg(ventas) from libros);

Select autor_id from libros where ventas > 100;
---------------------------------Funciones-----------------------
DELIMITER //
CREATE FUNCTION Prestamo_libros()
RETURNS VARCHAR
BEGIN
  SET @disponibilidad = SELECT IF(Stock > 0, 'Disponible', 'No Disponible');
  RETURN @disponibilidad
END //
DELIMITER ;
---------------------------------Segunda parte----------------------------
SELECT
  CONCAT(usuarios.nombre, ' ', usuarios.apellidos) AS Usuarios_Con_Prestamos,
  usuarios.username,
  usuarios.email
FROM usuarios
INNER JOIN libros_usuarios ON usuarios.usuario_id = libros_usuarios.usuario_id
            AND libros_usuarios.fecha_creacion >= CURDATE() - interval 10 DAY;

SELECT
  usuarios.usuario_id,
  CONCAT(usuarios.nombre, ' ', usuarios.apellidos) AS Usuarios_Sin_Prestamos,
  usuarios.username,
  usuarios.email
FROM usuarios
LEFT JOIN libros_usuarios ON usuarios.usuario_id = libros_usuarios.usuario_id
            where libros_usuarios.usuario_id is not null
            GROUP BY usuario_id;

SELECT
  CONCAT(usuarios.nombre, ' ', usuarios.apellidos) AS Usuarios_Con_Mas_Prestamos,
  usuarios.username,
  usuarios.email,
  count(libros_usuarios.usuario_id) AS Cantidad_Prestamos
FROM usuarios
INNER JOIN libros_usuarios ON usuarios.usuario_id = libros_usuarios.usuario_id
            GROUP BY usuarios.usuario_id DESC;

SELECT
  libros.libro_id,
  libros.titulo,
  count(libros_usuarios.libro_id) as Cantidad_Prestamos
FROM libros
INNER JOIN libros_usuarios ON libros.libro_id = libros_usuarios.libro_id
            AND libros_usuarios.fecha_creacion >= CURDATE() - interval 30 DAY
            GROUP BY libros.libro_id DESC limit 5;

SELECT
  libros.libro_id,
  libros.autor_id,
  libros.titulo
FROM libros
LEFT JOIN libros_usuarios on libros.libro_id = libros_usuarios.libro_id
            WHERE libros_usuarios.libro_id IS NOT NULL;

SELECT
  libros.libro_id,
  libros.titulo,
  COUNT(libros_usuarios.libro_id)
FROM libros
INNER JOIN libros_usuarios ON libros.libro_id = libros_usuarios.libro_id
            AND date(libros_usuarios.fecha_creacion) = CURDATE()
            GROUP BY libros.libro_id DESC;

SELECT
  autores.autor_id,
  CONCAT(autores.nombre, ' ', autores.apellido) AS Nombre_Autor,
  COUNT(libros_usuarios.libro_id) AS Cantidad_Prestamos
FROM libros
INNER JOIN autores ON libros.autor_id = autores.autor_id
INNER JOIN libros_usuarios ON libros.libro_id = libros_usuarios.libro_id
            AND libros.autor_id = 1
            GROUP BY libros.autor_id;

SELECT
  autores.autor_id,
  CONCAT(autores.nombre, ' ', autores.apellido) AS Nombre_Autor,
  COUNT(libros_usuarios.libro_id) AS Cantidad_Prestamos
FROM libros
INNER JOIN autores ON libros.autor_id = autores.autor_id
INNER JOIN libros_usuarios ON libros.libro_id = libros_usuarios.libro_id
            GROUP BY libros.autor_id DESC limit 5;

SELECT
  libros.libro_id,
  libros.titulo,
  COUNT(libros_usuarios.libro_id)
FROM libros
INNER JOIN libros_usuarios ON libros.libro_id = libros_usuarios.libro_id
            AND libros_usuarios.fecha_creacion <= CURDATE() - interval - 5 DAY
            GROUP BY libros.libro_id DESC limit 1;
