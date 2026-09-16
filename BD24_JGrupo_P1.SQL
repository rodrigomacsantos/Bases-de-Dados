-- =========================================================
-- Autores: Autores: Lourenço Luís (a22406954), Rodrigo Santos (22306575), Lucas Moura (a22305109), Filipe Condeça (22306955), Rúben Graça (22307816)
-- Projeto: Sistema de Gestão Documental (SGD)
-- Fase 1: Estrutura Base do Sistema
-- =========================================================

-- Exercício 1: Identificação das entidades principais:
-- - Documento (entidade central)
-- - EstadoDocumento (estados possíveis do documento)
-- - TipoDocumento (tipos de documentos)
-- - UnidadeOrganica (departamentos)
-- - Utilizador (funcionários)
-- - LogAtividade (registro de ações)
-- - Notificacao (comunicações do sistema)

-- Exercícios 2, 3 e 4: Modelagem física do banco de dados
DROP DATABASE IF EXISTS projeto;
CREATE DATABASE projeto;
USE projeto;

-- Exercício 5: DDL para implementação do modelo

-- Tabela: EstadoDocumento
-- Exercício 6: Constraint UNIQUE no nome do estado
CREATE TABLE EstadoDocumento (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(50) UNIQUE NOT NULL,  -- Constraint 1.4: Estados não podem ter nomes iguais
    descricao TEXT,
    ordem INT NOT NULL
);

-- Tabela: TipoDocumento
-- Exercício 6: Constraint UNIQUE no nome do tipo
CREATE TABLE TipoDocumento (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(50) UNIQUE NOT NULL,  -- Constraint 1.4: Tipos não podem ter nomes iguais
    descricao TEXT,
    requer_aprovacao BOOLEAN DEFAULT TRUE
);

-- Tabela: UnidadeOrganica
-- Exercício 6: Constraint UNIQUE no nome da unidade
CREATE TABLE UnidadeOrganica (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) UNIQUE NOT NULL,  -- Constraint 1.4: UOs não podem ter nomes iguais
    codigo VARCHAR(20) UNIQUE NOT NULL,
    ativo BOOLEAN DEFAULT TRUE
);

-- Tabela: Utilizador
CREATE TABLE Utilizador (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    unidade_organica_id INT,
    cargo VARCHAR(100),
    nivel_acesso INT DEFAULT 1,
    ativo BOOLEAN DEFAULT TRUE,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (unidade_organica_id) REFERENCES UnidadeOrganica(id)
);

-- Tabela: Documento
-- Exercício 6: Implementação das constraints de negócio
CREATE TABLE Documento (
    id INT PRIMARY KEY AUTO_INCREMENT,
    numero_documento VARCHAR(50) NOT NULL,
    tipo_documento_id INT NOT NULL,
    estado_documento_id INT NOT NULL,
    unidade_organica_id INT NOT NULL,
    data_criacao DATE DEFAULT '2000-01-01',    -- Constraint 1.2: Data padrão
    data_insercao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Constraint 1.3: Data/hora inserção
    descricao TEXT NOT NULL,                   -- Constraint 1.1: Descrição obrigatória
    confidencial BOOLEAN DEFAULT FALSE,
    hiden BOOLEAN DEFAULT FALSE,
    chave_historico VARCHAR(255),
    valor_total DECIMAL(10,2),
    requer_arquivo_fisico BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (tipo_documento_id) REFERENCES TipoDocumento(id),
    FOREIGN KEY (estado_documento_id) REFERENCES EstadoDocumento(id),
    FOREIGN KEY (unidade_organica_id) REFERENCES UnidadeOrganica(id),
    CONSTRAINT chk_data_criacao CHECK (data_criacao >= '2000-01-01'),
    CONSTRAINT chk_descricao CHECK (descricao IS NOT NULL AND descricao != '')
);

-- Tabela: LogAtividade
CREATE TABLE LogAtividade (
    id INT PRIMARY KEY AUTO_INCREMENT,
    documento_id INT NOT NULL,
    acao VARCHAR(100) NOT NULL,
    data_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    utilizador_id INT NOT NULL,
    FOREIGN KEY (documento_id) REFERENCES Documento(id),
    FOREIGN KEY (utilizador_id) REFERENCES Utilizador(id)
);

-- Tabela: Notificacao
CREATE TABLE Notificacao (
    id INT PRIMARY KEY AUTO_INCREMENT,
    documento_id INT NOT NULL,
    destinatario_id INT NOT NULL,
    mensagem TEXT NOT NULL,
    data_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    lida BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (documento_id) REFERENCES Documento(id),
    FOREIGN KEY (destinatario_id) REFERENCES Utilizador(id)
);

-- Criação de índices para otimização
CREATE INDEX idx_documento_estado ON Documento(estado_documento_id);
CREATE INDEX idx_documento_tipo ON Documento(tipo_documento_id);
CREATE INDEX idx_documento_uo ON Documento(unidade_organica_id);
CREATE INDEX idx_log_documento ON LogAtividade(documento_id);
CREATE INDEX idx_notificacao_destinatario ON Notificacao(destinatario_id);