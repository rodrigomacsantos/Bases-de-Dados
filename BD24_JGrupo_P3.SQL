-- =========================================================
-- Autores: Autores: Lourenço Luís (a22406954), Rodrigo Santos (22306575), Lucas Moura (a22305109), Filipe Condeça (22306955), Rúben Graça (22307816)
-- Projeto: Sistema de Gestão Documental (SGD)
-- Fase 3: Funcionalidades Avançadas
-- =========================================================

USE projeto;

-- Exercício 1.1: Vista para documentos arquivados
CREATE VIEW DocumentosArquivados AS
SELECT *
FROM Documento d
WHERE d.estado_documento_id = (SELECT id FROM EstadoDocumento WHERE nome = 'Arquivado')
AND d.hiden = FALSE;

-- Exercício 1.2: Vista para documentos dos últimos 30 dias
CREATE VIEW DocumentosUltimos30Dias AS
SELECT *
FROM Documento d
WHERE d.data_insercao >= DATE_SUB(CURRENT_TIMESTAMP, INTERVAL 30 DAY)
AND d.hiden = FALSE;

-- Exercício 1.3: Vista para Certidões de Nascimento
CREATE VIEW CertidoesNascimento AS
SELECT 
    d.*,
    c.nome_certidao,
    c.data_expiracao
FROM Documento d
JOIN Certidao c ON d.id = c.documento_id
WHERE c.nome_certidao LIKE '%Nascimento%'
AND d.hiden = FALSE;

-- Exercício 1.4: Vista para documentos do Departamento Financeiro
CREATE VIEW DocumentosFinanceiro AS
SELECT d.*
FROM Documento d
JOIN UnidadeOrganica uo ON d.unidade_organica_id = uo.id
WHERE uo.nome = 'Departamento Financeiro'
AND d.hiden = FALSE;

DELIMITER //

-- Exercício 2.1: Função para histórico de documento
CREATE FUNCTION HistoricoDocumento(doc_id INT) 
RETURNS TEXT 
DETERMINISTIC
BEGIN
    DECLARE historico TEXT;
    SELECT GROUP_CONCAT(
        CONCAT(
            DATE_FORMAT(data_hora, '%d/%m/%Y %H:%i:%s'),
            ' - ',
            acao
        ) ORDER BY data_hora SEPARATOR '\n'
    ) INTO historico
    FROM LogAtividade
    WHERE documento_id = doc_id;
    RETURN COALESCE(historico, 'Sem histórico');
END //

-- Exercício 2.2: Função para último estado do documento
CREATE FUNCTION UltimoEstadoDocumento(doc_id INT)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    DECLARE estado VARCHAR(50);
    SELECT ed.nome INTO estado
    FROM Documento d
    JOIN EstadoDocumento ed ON d.estado_documento_id = ed.id
    WHERE d.id = doc_id AND d.hiden = FALSE;
    RETURN COALESCE(estado, 'Documento não encontrado');
END //

-- Exercício 2.3: Função para contagem de documentos por estado
CREATE FUNCTION ContarDocumentosPorEstado()
RETURNS TEXT
DETERMINISTIC
BEGIN
    DECLARE resultado TEXT;
    SELECT GROUP_CONCAT(
        CONCAT(ed.nome, ': ', COUNT(d.id))
        ORDER BY ed.ordem
        SEPARATOR '\n'
    ) INTO resultado
    FROM EstadoDocumento ed
    LEFT JOIN Documento d ON ed.id = d.estado_documento_id
    WHERE d.hiden = FALSE
    GROUP BY ed.id, ed.nome;
    RETURN COALESCE(resultado, 'Sem documentos');
END //

-- Exercício 2.4: Procedimento para listar documentos confidenciais
CREATE PROCEDURE ListarDocumentosConfidenciais()
BEGIN
    SELECT 
        d.numero_documento,
        d.descricao,
        uo.nome as unidade_organica,
        ed.nome as estado
    FROM Documento d
    JOIN UnidadeOrganica uo ON d.unidade_organica_id = uo.id
    JOIN EstadoDocumento ed ON d.estado_documento_id = ed.id
    WHERE d.confidencial = TRUE AND d.hiden = FALSE;
END //

-- Exercício 2.5: Procedimento para listar documentos do Jurídico
CREATE PROCEDURE ListarDocumentosJuridico()
BEGIN
    SELECT 
        d.numero_documento,
        d.descricao,
        UltimoEstadoDocumento(d.id) as estado_atual
    FROM Documento d
    JOIN UnidadeOrganica uo ON d.unidade_organica_id = uo.id
    WHERE uo.nome = 'Jurídico' AND d.hiden = FALSE;
END //

-- Exercício 2.6: Procedimento para contar ações do histórico
CREATE PROCEDURE ContarAcoesHistorico(IN doc_id INT)
BEGIN
    SELECT COUNT(*) as total_acoes
    FROM LogAtividade
    WHERE documento_id = doc_id;
END //

-- Exercício 3.1: Trigger para prevenir deleção física
CREATE TRIGGER BeforeDeleteDocument
BEFORE DELETE ON Documento
FOR EACH ROW
BEGIN
    UPDATE Documento SET hiden = TRUE WHERE id = OLD.id;
    SIGNAL SQLSTATE '45000' 
    SET MESSAGE_TEXT = 'Documentos não podem ser deletados fisicamente';
END //

-- Exercício 3.2: Trigger para registro de alterações
CREATE TRIGGER AfterUpdateDocument
AFTER UPDATE ON Documento
FOR EACH ROW
BEGIN
    INSERT INTO LogAtividade (documento_id, acao, utilizador_id, detalhe)
    SELECT 
        NEW.id,
        'Documento atualizado',
        1, -- Usuário padrão do sistema
        CONCAT(
            'Alterações: ',
            CASE 
                WHEN OLD.estado_documento_id != NEW.estado_documento_id THEN 'Estado modificado; '
                ELSE ''
            END,
            CASE 
                WHEN OLD.descricao != NEW.descricao THEN 'Descrição modificada; '
                ELSE ''
            END
        );
END //

-- Exercício 3.3: Trigger para implementação do blockchain
CREATE TRIGGER BeforeInsertDocument
BEFORE INSERT ON Documento
FOR EACH ROW
BEGIN
    DECLARE ultima_chave VARCHAR(255);
    
    -- Obtém a última chave
    SELECT chave_historico INTO ultima_chave
    FROM Documento 
    ORDER BY id DESC LIMIT 1;
    
    -- Se não houver última chave, usa '1' como inicial
    IF ultima_chave IS NULL THEN
        SET ultima_chave = '1';
    END IF;
    
    -- Gera nova chave usando hash
    SET NEW.chave_historico = SHA2(CONCAT(ultima_chave, NEW.numero_documento), 256);
END //

DELIMITER ;