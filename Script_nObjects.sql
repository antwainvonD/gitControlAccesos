/*
* Instalar IIS
* Verificar/Instalar/Descargar .NET Framework 4.5.1 (ASP.NET 4.5)
* Crear web site en IIS (control-accesos)
* Crear usuario en Intelisis para el control de accesos
*/
/*
* Configuración DB
*/
/*********** Nivel de compatibilidad a 90 ***********/
DECLARE
  @dbname  SYSNAME

SET @dbname = DB_NAME()

IF (SELECT cmptlevel FROM MASTER.dbo.sysdatabases WHERE name = @dbname) < 90
  EXEC sp_dbcmptlevel @dbname/*'CGP'*/, 90
GO

/*********** Implementacion MD5 ***********/
IF(SELECT value_in_use FROM sys.configurations WHERE name = 'clr enabled') = 0
BEGIN
  EXEC sp_configure 'clr enabled', 1
  RECONFIGURE
END
GO
/*
* CLR
*/
/*********** dbo.fnPassword ***********/
IF OBJECT_ID('dbo.fnPassword', 'FS') IS NOT NULL DROP FUNCTION dbo.fnPassword
GO
IF EXISTS(SELECT * FROM sys.assemblies WHERE name ='asPassword') DROP ASSEMBLY asPassword
GO
CREATE ASSEMBLY asPassword
AUTHORIZATION [dbo]
FROM 0x4D5A90000300000004000000FFFF0000B800000000000000400000000000000000000000000000000000000000000000000000000000000000000000800000000E1FBA0E00B409CD21B8014CCD21546869732070726F6772616D2063616E6E6F742062652072756E20696E20444F53206D6F64652E0D0D0A2400000000000000504500004C0103003769C4510000000000000000E00002210B010B00000C000000060000000000009E2B0000002000000040000000000010002000000002000004000000000000000400000000000000008000000002000000000000030040850000100000100000000010000010000000000000100000000000000000000000502B00004B000000004000004003000000000000000000000000000000000000006000000C000000182A00001C0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000200000080000000000000000000000082000004800000000000000000000002E74657874000000A40B000000200000000C000000020000000000000000000000000000200000602E72737263000000400300000040000000040000000E0000000000000000000000000000400000402E72656C6F6300000C0000000060000000020000001200000000000000000000000000004000004200000000000000000000000000000000802B0000000000004800000002000500DC2100003C080000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000013300300FD000000010000110012007201000070281000000A0012017221000070281000000A0012020F00FE16020000016F1100000A2802000006281000000A001202281200000A6F1300000A281400000A0C12031202281200000A6F1500000A281600000A00091F23281700000A281800000A281900000A2D03082B141202281200000A191F206F1A00000A281400000A000C0608281B00000A07281B00000A0C12041202FE16020000016F1100000A2802000006281000000A0012051204281200000A6F1500000A281600000A0011051F23281700000A281800000A281900000A2D0411042B141204281200000A191F206F1A00000A281400000A001304110413062B0011062A000000133003006B0000000200001100731C00000A0A281D00000A026F1E00000A0B06076F1F00000A0B732000000A0C000713051613062B2611051106910D000812037239000070282100000A6F1300000A6F2200000A2600110617581306110611058E69FE04130711072DCC086F1100000A13042B0011042A1E02282300000A2A0042534A4201000100000000000C00000076322E302E35303732370000000005006C0000009C020000237E0000080300009803000023537472696E677300000000A00600004000000023555300E0060000100000002347554944000000F00600004C01000023426C6F620000000000000002000001471502000900000000FA253300160000010000001A000000020000000300000002000000230000000D00000002000000010000000200000000000A000100000000000600390032000A0061004C0006009C008A000600B3008A000600D0008A000600EF008A00060008018A00060021018A0006003C018A00060057018A0006008F0170010600A30170010600B1018A000600CA018A000600FA01E7013F000E02000006003D021D0206005D021D020600960232000A00BC024C000A00C5024C00060021030403060046033A0306006103040306007B033A0306008903320000000000010000000000010001000100100016001F0005000100010050200000000096006B000A0001005C210000000096006F0011000200D3210000000086187A001600030000000100800000000100840019007A001A0021007A001A0029007A001A0031007A001A0039007A001A0041007A001A0049007A001A0051007A001A0059007A001F0061007A001A0069007A001A0071007A001A0079007A00240089007A002A0091007A00160011007A001A00090083022F0011008C022F0099009D022F001100A50233009900B1023900A1007A002A00A100A5023D00A100D0024300A900E6024C009900EE0252001100F8025800B1007A001600B9004F037200B90058037700C1006F037D00C9007A001600D10083028400C9008E03890009007A0016002E000B009E002E001300AB002E001B00AB002E002300B1002E002B009E002E003300C0002E003B00AB002E004B00AB002E005300E1002E0063000B012E006B0018012E00730021012E007B002A0161008F000480000001000000000000000000000000007B020000020000000000000000000000010029000000000002000000000000000000000001004000000000000000003C4D6F64756C653E006C6F77776361742E646C6C00496E744669726D6100496E74656C69736973006D73636F726C69620053797374656D004F626A6563740053797374656D2E446174610053797374656D2E446174612E53716C54797065730053716C537472696E6700636174004765744D443548617368002E63746F720063616400696E7075740053797374656D2E5265666C656374696F6E00417373656D626C795469746C6541747472696275746500417373656D626C794465736372697074696F6E41747472696275746500417373656D626C79436F6E66696775726174696F6E41747472696275746500417373656D626C79436F6D70616E7941747472696275746500417373656D626C7950726F6475637441747472696275746500417373656D626C79436F7079726967687441747472696275746500417373656D626C7954726164656D61726B41747472696275746500417373656D626C7943756C747572654174747269627574650053797374656D2E52756E74696D652E496E7465726F70536572766963657300436F6D56697369626C65417474726962757465004775696441747472696275746500417373656D626C7956657273696F6E41747472696275746500417373656D626C7946696C6556657273696F6E4174747269627574650053797374656D2E446961676E6F73746963730044656275676761626C6541747472696275746500446562756767696E674D6F6465730053797374656D2E52756E74696D652E436F6D70696C6572536572766963657300436F6D70696C6174696F6E52656C61786174696F6E734174747269627574650052756E74696D65436F6D7061746962696C697479417474726962757465006C6F777763617400546F537472696E67006765745F56616C756500537472696E6700546F4C6F776572006F705F496D706C69636974006765745F4C656E6774680053716C496E7433320053716C426F6F6C65616E006F705F477265617465725468616E4F72457175616C006F705F5472756500537562737472696E67006F705F4164646974696F6E0053797374656D2E53656375726974792E43727970746F677261706879004D443543727970746F5365727669636550726F76696465720053797374656D2E5465787400456E636F64696E67006765745F555446380047657442797465730048617368416C676F726974686D00436F6D707574654861736800537472696E674275696C646572004279746500417070656E6400000000001F4B006E0054005A007900630030004D0042006100640052006B00410041000017300073006B006B0072006C00460075004F002F0069000005780032000000C9AC479D23BAE74C83EAE859CE01B0EF0008B77A5C561934E089060001110911090400010E0E03200001042001010E042001010205200101114104200101080320000E05000111090E032000080500011151080800021155115111510500010211550520020E08080800021109110911091007071109110911091151110911511109040000125D0520011D050E0620011D051D050420010E0E05200112650E0E070812591D051265050E1D0508020C0100076C6F777763617400000501000000000E0100094D6963726F736F667400002001001B436F7079726967687420C2A9204D6963726F736F6674203230313300002901002463663731313261632D616364632D343732652D383562302D33353030393762303334613700000C010007312E302E302E3000000801000701000000000801000800000000001E01000100540216577261704E6F6E457863657074696F6E5468726F777301000000000000003769C45100000000020000001C010000342A0000340C00005253445362307CDCD1291248AAD941646668553001000000643A5C50726F796563746F735C5665727369C3B36E5C32303133303632315C6C6F77776361745C6C6F77776361745C6F626A5C44656275675C6C6F77776361742E706462000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000782B000000000000000000008E2B0000002000000000000000000000000000000000000000000000802B00000000000000005F436F72446C6C4D61696E006D73636F7265652E646C6C0000000000FF2500200010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100100000001800008000000000000000000000000000000100010000003000008000000000000000000000000000000100000000004800000058400000E80200000000000000000000E80234000000560053005F00560045005200530049004F004E005F0049004E0046004F0000000000BD04EFFE00000100000001000000000000000100000000003F000000000000000400000002000000000000000000000000000000440000000100560061007200460069006C00650049006E0066006F00000000002400040000005400720061006E0073006C006100740069006F006E00000000000000B00448020000010053007400720069006E006700460069006C00650049006E0066006F00000024020000010030003000300030003000340062003000000034000A00010043006F006D00700061006E0079004E0061006D006500000000004D006900630072006F0073006F00660074000000380008000100460069006C0065004400650073006300720069007000740069006F006E00000000006C006F00770077006300610074000000300008000100460069006C006500560065007200730069006F006E000000000031002E0030002E0030002E003000000038000C00010049006E007400650072006E0061006C004E0061006D00650000006C006F00770077006300610074002E0064006C006C0000005C001B0001004C006500670061006C0043006F007000790072006900670068007400000043006F0070007900720069006700680074002000A90020004D006900630072006F0073006F0066007400200032003000310033000000000040000C0001004F0072006900670069006E0061006C00460069006C0065006E0061006D00650000006C006F00770077006300610074002E0064006C006C000000300008000100500072006F0064007500630074004E0061006D006500000000006C006F00770077006300610074000000340008000100500072006F006400750063007400560065007200730069006F006E00000031002E0030002E0030002E003000000038000800010041007300730065006D0062006C0079002000560065007200730069006F006E00000031002E0030002E0030002E0030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002000000C000000A03B00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
WITH PERMISSION_SET = SAFE
GO
CREATE FUNCTION dbo.fnPassword (@cad NVARCHAR(max))
RETURNS NVARCHAR(max)
AS
  EXTERNAL NAME [asPassword].[Intelisis.IntFirma].cat; 
GO
/*
* Tablas
*/
-- SELECT * FROM TablaSt
/*********** dbo.TablaSt ***********/
IF OBJECT_ID('dbo.TablaSt', 'U') IS NULL -- DROP TABLE TablaSt
  CREATE TABLE dbo.TablaSt(
    TablaSt     VARCHAR(50) CONSTRAINT priTablaSt PRIMARY KEY CLUSTERED 
  )
GO
-- SELECT * FROM TablaStD
/*********** dbo.TablaStD ***********/
IF OBJECT_ID('dbo.TablaStD', 'U') IS NULL -- DROP TABLE TablaStD
  CREATE TABLE dbo.TablaStD(
    TablaSt     VARCHAR(50),
    Nombre      VARCHAR(50),
    Valor       VARCHAR(50)

    CONSTRAINT priTablaStD PRIMARY KEY CLUSTERED (TablaSt, Nombre)
  )
GO

-- SELECT * FROM MobileAcceso_Invitados
/*********** dbo.MobileAcceso_Invitados ***********/
IF OBJECT_ID('dbo.MobileAcceso_Invitados', 'U') IS NULL -- DROP TABLE MobileAcceso_Invitados
  CREATE TABLE dbo.MobileAcceso_Invitados(
    Fecha       DATETIME,
    Cte         VARCHAR(20),
    CteEnviarA  INT,
    Invitado    VARCHAR(100),
    Empresa     CHAR(5),
	Cedula		VARCHAR(50),
	Usuario		CHAR(10)
  )
GO

-- SELECT * FROM MobileAcceso_Movimientos
/*********** dbo.MobileAcceso_Movimientos ***********/
IF OBJECT_ID('dbo.MobileAcceso_Movimientos', 'U') IS NULL -- DROP TABLE dbo.MobileAcceso_Movimientos
  CREATE TABLE dbo.MobileAcceso_Movimientos(
    Fecha       DATETIME,
    Cte         VARCHAR(20),
    CteEnviarA  INT,
    Invitado    VARCHAR(100),
    Empresa     VARCHAR(5),
	Cedula		VARCHAR(50),
	Usuario		VARCHAR(10),
	Puerta      INT,
    Area        VARCHAR(50),
    Estatus     VARCHAR(15)
  )
GO
IF NOT EXISTS(SELECT so.[object_id] FROM sys.objects so JOIN sys.[columns] sc ON so.[object_id] = sc.[object_id]
               WHERE so.[object_id] = OBJECT_ID('dbo.MobileAcceso_Movimientos', 'U') AND sc.name = 'Area')
BEGIN
  ALTER TABLE dbo.MobileAcceso_Movimientos ADD Area VARCHAR(50)
END
GO
IF EXISTS(SELECT so.[object_id] FROM sys.objects so JOIN sys.[columns] sc ON so.[object_id] = sc.[object_id]
           WHERE so.[object_id] = OBJECT_ID('dbo.MobileAcceso_Movimientos', 'U') AND sc.name = 'Area')
BEGIN
  UPDATE MobileAcceso_Movimientos
     SET Area = 'CANCHA GOLF'
   WHERE Area IS NULL

  ALTER TABLE dbo.MobileAcceso_Movimientos ALTER COLUMN Area VARCHAR(50) NOT NULL
END
GO

IF NOT EXISTS(SELECT so.[object_id] FROM sys.objects so JOIN sys.[columns] sc ON so.[object_id] = sc.[object_id]
               WHERE so.[object_id] = OBJECT_ID('dbo.MobileAcceso_Movimientos', 'U') AND sc.name = 'Estatus')
BEGIN
  ALTER TABLE dbo.MobileAcceso_Movimientos ADD Estatus VARCHAR(15)
END
GO

IF EXISTS(SELECT so.[object_id] FROM sys.objects so JOIN sys.[columns] sc ON so.[object_id] = sc.[object_id]
          WHERE so.[object_id] = OBJECT_ID('dbo.MobileAcceso_Movimientos', 'U') AND sc.name = 'Estatus')
BEGIN
  UPDATE a
     SET a.Estatus = c.Estatus
    FROM MobileAcceso_Movimientos   a
    JOIN Cte                        c   ON a.Cte = c.Cliente
   WHERE a.Estatus IS NULL

  ALTER TABLE dbo.MobileAcceso_Movimientos ALTER COLUMN Estatus VARCHAR(15)
END
GO
/*
* Índices
*/
IF NOT EXISTS (SELECT so.[object_id] FROM sys.objects so JOIN sys.indexes si ON so.[object_id] = si.[object_id]
                WHERE so.[object_id] = OBJECT_ID('dbo.MobileAcceso_Movimientos', 'U') AND si.name = 'idx_Invitado_01')
BEGIN
  CREATE INDEX idx_Invitado_01 ON dbo.MobileAcceso_Movimientos (Cedula, Invitado, Fecha, CteEnviarA, Cte)
END ELSE
BEGIN
  DROP INDEX dbo.MobileAcceso_Movimientos.idx_Invitado_01
  CREATE INDEX idx_Invitado_01 ON dbo.MobileAcceso_Movimientos (Cedula, Invitado, Fecha, CteEnviarA, Cte)
END
GO
/*
* Vistas
*/
IF OBJECT_ID('dbo.vMobileAcceso_Invitados') IS NOT NULL DROP VIEW dbo.vMobileAcceso_Invitados
GO
CREATE VIEW dbo.vMobileAcceso_Invitados
AS
  SELECT c.Cte                  AS Cte,
	     c.Invitado             AS Invitado,
	     c.Cedula               AS Cedula,
         c.Fecha                AS Fecha,
	     1                      AS Visitas
	FROM MobileAcceso_Movimientos c
   WHERE c.Cedula <> ''

  UNION ALL

  SELECT c.Cte                  AS Cte,
	     c.Invitado             AS Invitado,
	     c.Cedula               AS Cedula,
         c.Fecha                AS Fecha,
	     0                      AS Visitas
	FROM MobileAcceso_Invitados c
GO
/*
* Datos
*/
/*********** wControlAcceso ***********/
IF NOT EXISTS (SELECT * FROM TablaSt WHERE TablaSt = 'wControlAcceso')
  INSERT TablaSt VALUES ('wControlAcceso')
GO
IF NOT EXISTS (SELECT * FROM TablaStD WHERE TablaSt = 'wControlAcceso' AND Nombre = 'wRutaFotos')
  INSERT TablaStD VALUES ('wControlAcceso', 'wRutaFotos',
  /*Ruta local del site donde se almacenan las imagenes*/'C:\inetpub\wwwroot\CGP\pruebas\Img\')
GO
IF NOT EXISTS (SELECT * FROM TablaStD WHERE TablaSt = 'wControlAcceso' AND Nombre = 'wExtFotos')
  INSERT TablaStD VALUES ('wControlAcceso', 'wExtFotos', '.jpg')-- extensión de las imágenes que se utilizarán
GO
IF NOT EXISTS (SELECT * FROM TablaStD WHERE TablaSt = 'wControlAcceso' AND Nombre = 'wMaxInvitados')
  INSERT TablaStD VALUES ('wControlAcceso', 'wMaxInvitados', '3')
GO
IF NOT EXISTS (SELECT * FROM TablaStD WHERE TablaSt = 'wControlAcceso' AND Nombre = 'wEmpresa')
  INSERT TablaStD VALUES ('wControlAcceso', 'wEmpresa', 'CGP')
  GO
IF NOT EXISTS (SELECT * FROM TablaStD WHERE TablaSt = 'wControlAcceso' AND Nombre = 'wPuerta')
  INSERT TablaStD VALUES ('wControlAcceso', 'wPuerta', '1')
GO
IF NOT EXISTS (SELECT * FROM TablaStD WHERE TablaSt = 'wControlAcceso' AND Nombre = 'wPasswordType')
  INSERT TablaStD VALUES ('wControlAcceso', 'wPasswordType', '2')
  /*2 = nuevo, 1 = viejo (la compatibilidad 80 no es necesaria) */
GO
IF NOT EXISTS (SELECT * FROM GrupoTrabajo WHERE GrupoTrabajo = 'Control Accesos')
  INSERT GrupoTrabajo (GrupoTrabajo) VALUES ('Control Accesos')
GO
--UPDATE Usuario SET Estatus = 'ALTA', GrupoTrabajo = 'Control Accesos' WHERE Usuario ='MASTER'
--GO
/*
* Funciones
*/
--SELECT dbo.fnFechaSinHora(GETDATE)
/**************** fnFechaSinHora ****************/
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'fnFechaSinHora' AND type = 'FN') DROP FUNCTION fnFechaSinHora
GO
CREATE FUNCTION fnFechaSinHora (@Fecha	datetime)
RETURNS datetime
--//WITH ENCRYPTION
AS BEGIN
  RETURN (DATEADD(ms, -DATEPART(ms, @Fecha), DATEADD(ss, -DATEPART(ss, @Fecha), DATEADD(mi, -DATEPART(mi, @Fecha), DATEADD(hh, -DATEPART(hh, @Fecha), @Fecha)))))
END
GO
--SELECT dbo.ufnPasswordOld('control')
/**************** ufnPasswordOld ****************/
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'ufnPasswordOld' AND type = 'FN') DROP FUNCTION ufnPasswordOld
GO
CREATE FUNCTION ufnPasswordOld (@pwd VARCHAR(MAX))
RETURNS VARCHAR(32)
--//WITH ENCRYPTION
AS BEGIN
  RETURN (SUBSTRING(master.dbo.fn_varbintohexstr(HashBytes('MD5', @pwd)), 3, 32))
END
GO
/*
* Procedimientos almacenados
*/
/*********** dbo.MobileAcceso_login ***********/
IF OBJECT_ID('dbo.MobileAcceso_login', 'P') IS NOT NULL DROP PROCEDURE dbo.MobileAcceso_login
GO
CREATE PROCEDURE dbo.MobileAcceso_login
                @Empresa        CHAR(5),
                @Usuario        VARCHAR(10),
                @Pass           VARCHAR(50),
                @Puerta         INT
AS BEGIN
  DECLARE
    @pwdType    INT

  SELECT @pwdType = Valor FROM TablaStD WHERE TablaSt = 'wControlAcceso' AND Nombre = 'wPasswordType'
  -- si este procedimiento regresa renglones el acceso sera denegado al sistema de accesos del club de golf
  SELECT TOP 1 u.Usuario    AS Usuario,
         @Pass              AS Pass
    FROM Usuario u
    WHERE u.Usuario = RTRIM(@Usuario)
 	  AND u.Estatus = 'ALTA'
 	  AND u.Contrasena = CASE @pwdType
                             WHEN 1 THEN dbo.ufnPasswordOld(@Pass)    -- versión vieja de encriptación
                             WHEN 2 THEN dbo.fnPassword(@Pass)        -- versión nueva de encriptación (CLR)
                         END
      AND u.GrupoTrabajo = 'Control Accesos'        -- cambiar este grupo o criterio en caso de ser necesario
END
GO
/*********** dbo.MobileAcceso_Parametros ***********/
IF OBJECT_ID('dbo.MobileAcceso_Parametros', 'P') IS NOT NULL DROP PROCEDURE dbo.MobileAcceso_Parametros
GO
CREATE PROCEDURE dbo.MobileAcceso_Parametros
AS BEGIN
  DECLARE 
	@Empresa        VARCHAR(5),
	@Puerta         INT,
	@maxInvitados   INT

  SELECT @Empresa       = Valor               FROM TablaStD WHERE TablaSt = 'wControlAcceso' AND Nombre = 'wEmpresa'
  SELECT @puerta        = CONVERT(int, Valor) FROM TablaStD WHERE TablaSt = 'wControlAcceso' AND Nombre = 'wPuerta'
  SELECT @Maxinvitados  = CONVERT(int, Valor) FROM TablaStD WHERE TablaSt = 'wControlAcceso' AND Nombre = 'wMaxInvitados'
	
  SELECT @Empresa           AS Empresa,
         @Puerta            AS Puerta,
         @Maxinvitados      AS maxInvitados 
END
GO

--EXEC dbo.MobileAcceso_CteDependientes @Cliente='100000-1',@Empresa='CGP ',@Puerta=1
/*********** dbo.MobileAcceso_CteDependientes ***********/
IF OBJECT_ID('dbo.MobileAcceso_CteDependientes', 'P') IS NOT NULL DROP PROCEDURE dbo.MobileAcceso_CteDependientes
GO
CREATE PROCEDURE dbo.MobileAcceso_CteDependientes
                @Cliente        VARCHAR(20), 
                @Empresa        CHAR(5), 
                @Puerta         INT
AS BEGIN
  DECLARE
    @Cte        VARCHAR(20),
    @Dep        INT,
    @Ruta       VARCHAR(100),
    @Ext        VARCHAR(5),
    @Caracter   INT

  SET @Caracter = CHARINDEX('-', @Cliente, 1)

  IF @Caracter > 0
    SELECT @Cte = SUBSTRING(@Cliente, 1, CHARINDEX('-', @Cliente, 1)-1),
           @Dep = SUBSTRING(@Cliente, CHARINDEX('-', @Cliente, 1)+1, LEN(@Cliente))
  ELSE
    SELECT @Cte = @Cliente, @Dep = 1
         
  SELECT @Ruta = Valor -- Ruta de las fotos
    FROM TablaStD
   WHERE TablaSt = 'wControlAcceso'
     AND Nombre = 'wRutaFotos'

    SELECT @Ext = Valor -- Extensión de las fotos
    FROM TablaStD
   WHERE TablaSt = 'wControlAcceso'
     AND Nombre = 'wExtFotos'

  SELECT UPPER(RTRIM(c.Cliente)+'-'+CONVERT(VARCHAR, c.ID))    AS Clave,
         UPPER(c.Nombre)                                       AS Nombre,
         UPPER(ISNULL(c.Grupo, 'NA'))                          AS Relacion,
         RTRIM(@Ruta)+RTRIM(c.Cliente)+'-'+CONVERT(VARCHAR, c.ID)+RTRIM(@Ext)   AS Foto
    FROM CteEnviarA c
   WHERE c.Cliente = @Cte
     --AND CASE WHEN @Caracter > 0 THEN c.ID ELSE 1 END = CASE WHEN @Caracter > 0 THEN @Dep ELSE 1 END
END
GO
--EXEC dbo.MobileAcceso_CteInvitados @Cliente='100000-1',@Empresa='CGP ',@Puerta=1
/*********** dbo.MobileAcceso_CteInvitados ***********/
IF OBJECT_ID('dbo.MobileAcceso_CteInvitados', 'P') IS NOT NULL DROP PROCEDURE dbo.MobileAcceso_CteInvitados
GO
CREATE PROCEDURE dbo.MobileAcceso_CteInvitados
                @Cliente        VARCHAR(20), 
                @Empresa        CHAR(5), 
                @Puerta         INT
AS BEGIN
  DECLARE
    @Cte        VARCHAR(20),
    @Dep        VARCHAR(20),
    @Caracter   INT

  SET @Caracter = CHARINDEX('-', @Cliente, 1)

  IF @Caracter > 0
    SELECT @Cte = SUBSTRING(@Cliente, 1, CHARINDEX('-', @Cliente, 1)-1),
           @Dep = SUBSTRING(@Cliente, CHARINDEX('-', @Cliente, 1)+1, LEN(@Cliente))
  ELSE
    SELECT @Cte = @Cliente
 
  -- se accesa a la vista que contiene el UNION de la tabla Invitados y Movimientos
  SELECT UPPER(c.Cte)                  AS Clave,
	     UPPER(MAX(c.Invitado))        AS Nombre,
	     UPPER(c.Cedula)               AS Cedula,
         a.VisitasGlobales      AS Visitas -- se modifica la sumatoria de visitas, se hace global y se busca por cedula
	     --SUM(c.Visitas)         AS Visitas
	FROM vMobileAcceso_Invitados    c
    JOIN (SELECT SUM(Visitas) AS VisitasGlobales, Cedula
            FROM vMobileAcceso_Invitados
           GROUP BY Cedula) AS      a       ON c.Cedula = a.Cedula
   WHERE c.Cte = @Cte
     AND MONTH(c.Fecha) = MONTH(GETDATE())
     AND YEAR(c.Fecha) = YEAR(GETDATE())
     AND c.Cedula <> ''
   GROUP BY c.Cte, c.Cedula, a.VisitasGlobales
END
GO
--EXEC dbo.MobileAcceso_CteData @Cliente='100000-1',@Empresa='CGP ',@Puerta=1
/*********** dbo.MobileAcceso_CteData ***********/
IF OBJECT_ID('dbo.MobileAcceso_CteData', 'P') IS NOT NULL DROP PROCEDURE dbo.MobileAcceso_CteData
GO
CREATE PROCEDURE MobileAcceso_CteData
                @Cliente        VARCHAR(20), 
                @Empresa        CHAR(5), 
                @Puerta         INT
AS BEGIN
  DECLARE
    @Cte            VARCHAR(20),
    @Dep            INT,
    @Nombre         VARCHAR(100),
    @Caracter       INT,
    @Fecha          DATETIME,
	@Saldo          FLOAT,
	@Foto           VARCHAR(255),
    @Ext            VARCHAR(5),
	@VisibleSaldo   BIT,
    @Mensaje        VARCHAR(255),
    @Estatus		VARCHAR(15),

    @Parentesco     VARCHAR(50)

  SET @Caracter = CHARINDEX('-', @Cliente, 1)

  IF @Caracter > 0
    SELECT @Cte = SUBSTRING(@Cliente, 1, CHARINDEX('-', @Cliente, 1)-1),
	       @Dep = SUBSTRING(@Cliente, CHARINDEX('-', @Cliente, 1)+1, LEN(@Cliente))
  ELSE
    SELECT @Cte = @Cliente, @Dep = 1

  SELECT @Ext = Valor -- Extensión de las fotos
    FROM TablaStD
   WHERE TablaSt = 'wControlAcceso'
     AND Nombre = 'wExtFotos'

  SELECT @Foto = RTRIM(Valor)+RTRIM(@Cliente)+RTRIM(@Ext),
         @VisibleSaldo = 0,
         @Saldo = 0
    FROM TablaStD
   WHERE TablaSt = 'wControlAcceso'
     AND Nombre = 'wRutaFotos'

  SELECT @Nombre = 'Nombre: '+UPPER(Nombre),
         @Fecha = ISNULL(FechaNacimiento, '01/01/1900'),
         @Parentesco = 'Tipo Socio: '+CASE WHEN UPPER(Grupo) = 'PRINCIPAL' THEN '' ELSE 'DEPENDIENTE - ' END+UPPER(Grupo)
    FROM CteEnviarA
   WHERE Cliente = @Cte
     AND CASE WHEN @Caracter > 0 THEN ID ELSE 1 END = CASE WHEN @Caracter > 0 THEN @Dep ELSE 1 END

  IF YEAR(@Fecha) > 1900
  BEGIN
    IF MONTH(@Fecha) = MONTH(GETDATE()) AND DAY(@Fecha) = DAY(GETDATE())
      SELECT @Fecha = dbo.fnFechaSinHora(GETDATE())
  END

  SELECT @Mensaje = ISNULL(Mensaje, ''),
         @Estatus = ISNULL(NULLIF(Estatus, ''), 'SIN_ESTATUS')
    FROM Cte
   WHERE Cliente = CASE WHEN @Caracter > 0 THEN @Cte ELSE @Cliente END
	
  SELECT UPPER(@Cliente)            AS Cliente,
	     @Nombre                    AS Nombre,
	     ''                         AS Apellido,	  
	     UPPER(@Estatus)            AS Estatus,
	     @Parentesco                AS Parentesco, 
	     UPPER(@Mensaje)            AS Mensaje,
	     @Fecha                     AS FechaNacimiento,
	     0                          AS Sexo,
	     @Saldo                     AS Saldo,
	     @Foto                      AS Foto,
	     @VisibleSaldo              AS VisibleSaldo
END
GO
/*********** dbo.MobileAcceso_Areas ***********/
IF OBJECT_ID('dbo.MobileAcceso_Areas', 'P') IS NOT NULL DROP PROCEDURE dbo.MobileAcceso_Areas
GO
CREATE PROCEDURE dbo.MobileAcceso_Areas
AS BEGIN
  SELECT 'SELECCIONAR AREA' AS Area
  UNION ALL
  SELECT DISTINCT Elemento
    FROM SoporteElemento   -- colocar la tabla correspondiente en caso que se requiera modificar
END
GO
/*********** dbo.MobileAcceso_Eventos ***********/
IF OBJECT_ID('dbo.MobileAcceso_Eventos', 'P') IS NOT NULL DROP PROCEDURE dbo.MobileAcceso_Eventos
GO
CREATE PROCEDURE dbo.MobileAcceso_Eventos 
                @Empresa        CHAR(5),
                @Puerta         INT
AS BEGIN
  DECLARE
    @Time            DATETIME,
	@Descripcion     VARCHAR(200)
	
  SET @Time = GETDATE()
  SET @Descripcion = 'Carga empleado'

  SELECT @Time          AS Hora,
	     @Descripcion   AS Evento
END
GO
--EXEC dbo.MobileAcceso_Registros @Empresa='CGP  ',@Puerta=1,@Usuario='master'
/*********** dbo.MobileAcceso_Registros ***********/
IF OBJECT_ID('dbo.MobileAcceso_Registros', 'P') IS NOT NULL DROP PROCEDURE dbo.MobileAcceso_Registros
GO
CREATE PROCEDURE dbo.MobileAcceso_Registros
                @Empresa        VARCHAR(5),
                @Puerta         INT,
                @Usuario		VARCHAR(10)
AS BEGIN
  SELECT TOP 10
         CONVERT(VARCHAR(50), m.Fecha, 101)             AS Fecha, 
         CONVERT(VARCHAR(50), m.Fecha, 108)             AS Hora,
  -- hacer una concatenacion evitando es null de los campos
<<<<<<< HEAD
         UPPER(CASE WHEN m.Cedula = ''
              THEN RTRIM(RTRIM(m.Cte))+'-'+CONVERT(varchar, ISNULL(m.CteEnviarA, ''))
              ELSE ISNULL(RTRIM(m.Cedula), '')
         END)                                           AS Clave,
         UPPER(CASE WHEN m.Cedula = ''
              THEN RTRIM(c.Nombre)
              ELSE ISNULL(RTRIM(m.Invitado), '')
         END)                                           AS Nombre,
         UPPER(Area)                                    AS Area,
         CASE WHEN m.Cedula = ''
              THEN ''
              ELSE 'Invitado'
         END                                            AS Tipo
   --, CteEnviarA, Invitado, Empresa, Cedula, m.Usuario
  FROM MobileAcceso_Movimientos m
  JOIN CteEnviarA               c   ON m.Cte = c.Cliente AND m.CteEnviarA = c.ID
  ORDER BY Fecha DESC, Hora DESC
=======
         '('+ CASE WHEN m.Cedula = ''
                THEN RTRIM(RTRIM(m.Cte))+'-'+CONVERT(varchar, ISNULL(m.CteEnviarA, ''))
                ELSE ISNULL(RTRIM(m.Cedula), '')
              END+') ' AS Clave,
              CASE WHEN m.Cedula = ''
                THEN RTRIM(c.Nombre)
                ELSE ISNULL(RTRIM(m.Invitado), '')
               END
  AS Nombre,
  Area, 
  CASE WHEN m.Cedula <> ''
                THEN 'Invitado'
                ELSE ''
              END AS Tipo
   --, CteEnviarA, Invitado, Empresa, Cedula, m.Usuario
  FROM MobileAcceso_Movimientos m
  JOIN CteEnviarA               c   ON m.Cte = c.Cliente AND m.CteEnviarA = c.ID
  -- WHERE @Usuario = mam.Usuario
  ORDER BY m.Fecha DESC
<<<<<<< Updated upstream
=======
>>>>>>> origin/Panama
>>>>>>> Stashed changes

  END
GO
--EXEC dbo.MobileAcceso_NuevoRegistro @Cedula='',@Cliente='100000-5',@Empresa='     ',@Usuario='master    ',@Puerta=1
/*********** dbo.MobileAcceso_NuevoRegistro ***********/
IF OBJECT_ID('dbo.MobileAcceso_NuevoRegistro', 'P') IS NOT NULL DROP PROCEDURE dbo.MobileAcceso_NuevoRegistro
GO
-- falta logica de insert
CREATE PROCEDURE MobileAcceso_NuevoRegistro
                @Cliente        VARCHAR(20), 
                @Cedula         VARCHAR(20), 
                @Empresa        VARCHAR(5), 
                @Usuario        VARCHAR(10),
                @Puerta         INT,
                @Area			VARCHAR(50)
AS BEGIN
  DECLARE
    @Cte            VARCHAR(20),
    @Dep            INT,
    @Caracter       INT,
    @Fecha          DATETIME,
    @Invitado       VARCHAR(100),
    @Estatus        VARCHAR(15)

  SELECT @Fecha = GETDATE(), @Caracter = CHARINDEX('-', @Cliente, 1), @Invitado = '', @Cedula = RTRIM(@Cedula)

  IF @Caracter > 0
    SELECT @Cte = SUBSTRING(@Cliente, 1, CHARINDEX('-', @Cliente, 1)-1),
	       @Dep = SUBSTRING(@Cliente, CHARINDEX('-', @Cliente, 1)+1, LEN(@Cliente))
  ELSE
    SELECT @Cte = @Cliente, @Dep = 1
  
  SELECT @Estatus = ISNULL(NULLIF(Estatus, ''), 'SIN_ESTATUS') FROM Cte WHERE Cliente = @Cte

  -- se extrae el nombre del invitado
  IF ISNULL(@Cedula, '') <> ''
  BEGIN
    SELECT TOP 1 @Invitado = Invitado
      FROM MobileAcceso_Invitados
     WHERE Cedula = @Cedula
       AND Invitado <> ''

    IF @Invitado = ''
      SELECT TOP 1 @Invitado = Invitado
        FROM MobileAcceso_Movimientos
       WHERE Cedula = @Cedula
         AND Invitado <> ''

    -- Se elimina el invitado "nuevo" que se ha escrito
    DELETE MobileAcceso_Invitados WHERE Cedula = @Cedula
  END

  INSERT INTO MobileAcceso_Movimientos (Fecha, Cte, CteEnviarA, Invitado, Empresa, Cedula, Usuario, Puerta, Area, Estatus)
  VALUES (@Fecha, @Cte, @Dep, UPPER(@Invitado), @Empresa, UPPER(@Cedula), UPPER(@Usuario), @Puerta, UPPER(@Area), UPPER(@Estatus))

END
GO

/*********** dbo.MobileAcceso_NuevoInvitado ***********/
IF OBJECT_ID('dbo.MobileAcceso_NuevoInvitado', 'P') IS NOT NULL DROP PROCEDURE dbo.MobileAcceso_NuevoInvitado
GO
-- falta logica de insert
CREATE PROCEDURE dbo.MobileAcceso_NuevoInvitado
                @Cliente    VARCHAR(20),
                @Invitado   VARCHAR (100),
                @Empresa    VARCHAR(5),
                @Puerta     INT,
                @Cedula     VARCHAR(50),
                @Usuario    VARCHAR (10)
AS BEGIN
  DECLARE
    @Cte        VARCHAR(20),
    @Dep        INT,
    @Caracter   INT,
    @Fecha      DATETIME

  SELECT @Fecha = GETDATE(), @Caracter = CHARINDEX('-', @Cliente, 1)

  IF @Caracter > 0
    SELECT @Cte = SUBSTRING(@Cliente, 1, CHARINDEX('-', @Cliente, 1)-1),
           @Dep = SUBSTRING(@Cliente, CHARINDEX('-', @Cliente, 1)+1, LEN(@Cliente))
  ELSE
    SELECT @Cte = @Cliente, @Dep = 1
		
  SET @Cedula = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@Cedula, ';', ''), '.', ''), ',', ''), '-', ''), '_', ''), '\', '')
  SET @Cedula = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@Cedula, '!', ''), '@', ''), '@', ''), '#', ''), '·', ''), '$', '')
  SET @Cedula = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@Cedula, '%', ''), '&', ''), '/', ''), '(', ''), ')', ''), '=', '')
  SET @Cedula = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@Cedula, '=', ''), '?', ''), '¿', ''), '¡', ''), '^', ''), '`', '')
  SET @Cedula = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@Cedula, '+', ''), '*', ''), '[', ''), ']', ''), '´', ''), '¨', '')
  SET @Cedula = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@Cedula, '{', ''), '}', ''), 'ç', ''), '<', ''), '>', ''), 'º', '')
  SET @Cedula = REPLACE(REPLACE(@Cedula, 'ª', ''), '¬', '')

  INSERT INTO MobileAcceso_Invitados (Fecha, Cte, CteEnviarA, Invitado, Empresa, Cedula, Usuario)
  VALUES (@Fecha, @Cte, @Dep , UPPER(@Invitado), @Empresa, UPPER(@Cedula), UPPER(@Usuario))
END
GO
/*
* re-Configuración DB
*/
/*********** Nivel de compatibilidad a 80 ***********/
DECLARE
  @dbname1  SYSNAME

SET @dbname1 = DB_NAME()

IF (SELECT CONVERT(INT, Valor) FROM TablaStD WHERE TablaSt = 'wControlAcceso' AND Nombre = 'wPasswordType') = 1
BEGIN
  EXEC sp_dbcmptlevel @dbname1/*'CGP'*/, 80
  EXEC sp_configure 'clr enabled', 0

  RECONFIGURE
END
GO