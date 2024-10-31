use ClinicaNewSun

--------------EXEMPLO 1--------------

IF EXISTS (SELECT 1 FROM SYS.objects WHERE TYPE = 'P' AND NAME = 'SP_ADD_CONSULTA')
	BEGIN
		DROP PROCEDURE SP_ADD_CONSULTA
	END
GO

CREATE PROCEDURE SP_ADD_CONSULTA
    @idConsulta INT,
    @dataConsulta DATE,
    @CRM VARCHAR(10),
    @idPaciente INT,
	@estado BIT
AS
    INSERT INTO Consulta (idConsulta, dataConsulta, CRM, idPaciente, estado)
    VALUES (@idConsulta, @dataConsulta, @CRM, @idPaciente, @estado);
GO

EXEC SP_ADD_CONSULTA
    @idConsulta = 6,
    @dataConsulta = '2024-06-12 13:0:00',
    @CRM = 'CRM65432',
    @idPaciente = 6,
	@estado = 0

SELECT * FROM Consulta

--------------EXEMPLO 2--------------

IF EXISTS (SELECT 1 FROM SYS.objects WHERE TYPE = 'P' AND NAME = 'SP_PESQUISA_CONSULTA')
	BEGIN
		DROP PROCEDURE SP_PESQUISA_CONSULTA
	END
GO

CREATE PROCEDURE SP_PESQUISA_CONSULTA
	@idDaConsulta INT
AS	

SELECT  
	idConsulta,
	dataConsulta,
	b.nome AS Paciente,
	c.nome AS Médico

FROM Consulta AS a
INNER JOIN Paciente AS b
ON a.idPaciente = b.idPaciente
INNER JOIN Medico AS c
ON a.CRM = c.CRM
WHERE idConsulta = @idDaConsulta

GO

EXEC SP_PESQUISA_CONSULTA 1

--------------EXEMPLO 3--------------

IF EXISTS (SELECT 1 FROM SYS.objects WHERE TYPE = 'P' AND NAME = 'SP_PESQUISA_MEDICO')
	BEGIN
		DROP PROCEDURE SP_PESQUISA_MEDICO
	END
GO

CREATE PROCEDURE SP_PESQUISA_MEDICO
	@CRMDoMedico VARCHAR(10)
AS	

SELECT 
	nome,
	a.CRM,
	STRING_AGG(c.Especialidade, ', ') AS 'Especialidades do Médico',
	email,
	dataNasc,
	CASE sexo
    WHEN 1 THEN 'Masculino' 
    ELSE 'Feminino'
	END  AS sexo,
	salarioMensal

FROM Medico AS a
INNER JOIN EspecialidadeMedico AS b
ON a.CRM = b.CRM
INNER JOIN Especialidades AS c
ON b.idEspecialidade = c.idEspecialidade

WHERE a.CRM = @CRMDoMedico
GROUP BY nome, a.CRM, email, dataNasc, sexo, salarioMensal;

GO

EXEC SP_PESQUISA_MEDICO @CRMDoMedico = 'CRM54321'

--------------EXEMPLO 4--------------

IF EXISTS (SELECT 1 FROM SYS.objects WHERE TYPE = 'P' AND NAME = 'SP_DELETAR_LINHAS')
BEGIN
    DROP PROCEDURE SP_DELETAR_LINHAS
END
GO

CREATE PROCEDURE SP_DELETAR_LINHAS
    @nomeTabela VARCHAR(30),
    @coluna VARCHAR(30),
    @idDaColuna INT
AS

    DECLARE @codigoDelete NVARCHAR(MAX)
    SET @codigoDelete = 'DELETE FROM ' + @nomeTabela + ' WHERE ' + @coluna + ' = @idDaColuna'
    EXEC sp_executesql @codigoDelete, N'@idDaColuna INT', @idDaColuna

GO

EXEC SP_DELETAR_LINHAS
    @nomeTabela = 'Paciente',
    @coluna = 'idPaciente',
    @idDaColuna = 21
 