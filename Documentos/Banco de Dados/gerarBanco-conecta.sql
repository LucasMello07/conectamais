CREATE DATABASE IF NOT EXISTS conecta;
USE conecta;

CREATE TABLE IF NOT EXISTS USUARIOS (
  id_usuario       INT AUTO_INCREMENT PRIMARY KEY,
  nome_completo    VARCHAR(100) NOT NULL,
  data_nascimento  DATE NOT NULL,
  genero           ENUM('Masculino','Feminino','Prefiro não dizer') NOT NULL,
  celular          VARCHAR(11) NOT NULL,
  email            VARCHAR(100) NOT NULL UNIQUE,
  senha            VARCHAR(255) NOT NULL,
  cpf_cnpj         VARCHAR(15) NOT NULL UNIQUE,
  endereco_rua     VARCHAR(100) NOT NULL,
  bairro           VARCHAR(50) NOT NULL,
  cidade           VARCHAR(50) NOT NULL,
  estado           CHAR(2) NOT NULL,
  tipo_usuario     ENUM('Cliente','Profissional','Administrador') NOT NULL,
  status_usuario   ENUM('ATIVO','SUSPENSO','BANIDO') DEFAULT 'ATIVO'
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS CLIENTES (
  id_cliente INT PRIMARY KEY,
  CONSTRAINT fk_clientes_usuario
    FOREIGN KEY (id_cliente) REFERENCES USUARIOS(id_usuario) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS PROFISSIONAIS (
  id_profissional    INT PRIMARY KEY,
  endereco_comercial VARCHAR(100),
  telefone_comercial VARCHAR(15) NOT NULL,
  CONSTRAINT fk_profissionais_usuario
    FOREIGN KEY (id_profissional) REFERENCES USUARIOS(id_usuario) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS ADMINISTRADOR (
  id_admin INT PRIMARY KEY,
  CONSTRAINT fk_admin_usuario
    FOREIGN KEY (id_admin) REFERENCES USUARIOS(id_usuario) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS HABILIDADES (
  id_habilidade   INT AUTO_INCREMENT PRIMARY KEY,
  titulo          VARCHAR(255) NOT NULL,
  descricao       VARCHAR(50)  NOT NULL,
  status          VARCHAR(50)  NOT NULL DEFAULT 'Ativo',
  id_profissional INT NOT NULL,
  CONSTRAINT fk_hab_prof
    FOREIGN KEY (id_profissional) REFERENCES PROFISSIONAIS(id_profissional) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS AGENDAMENTOS (
  id_agendamento      INT AUTO_INCREMENT PRIMARY KEY,
  id_cliente          INT NOT NULL,
  id_profissional     INT NOT NULL,
  data_agendamento    DATE NOT NULL,
  horario_agendamento TIME NOT NULL,
  status_agendamento  ENUM('Pendente','Concluído','Cancelado') DEFAULT 'Pendente',
  id_habilidade       INT NULL,
  CONSTRAINT fk_ag_cliente       FOREIGN KEY (id_cliente)      REFERENCES CLIENTES(id_cliente) ON DELETE CASCADE,
  CONSTRAINT fk_ag_profissional  FOREIGN KEY (id_profissional) REFERENCES PROFISSIONAIS(id_profissional) ON DELETE CASCADE,
  CONSTRAINT fk_ag_habilidade    FOREIGN KEY (id_habilidade)   REFERENCES HABILIDADES(id_habilidade)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS AVALIACOES (
  id_avaliacao        INT AUTO_INCREMENT PRIMARY KEY,
  id_cliente          INT NOT NULL,
  id_profissional     INT NOT NULL,
  id_agendamento      INT NOT NULL,
  nota                ENUM('Ruim','Regular','Bom','Ótimo','Excelente') NOT NULL,
  comentario_avaliacao VARCHAR(500),
  data_avaliacao      DATETIME DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_av_cli   FOREIGN KEY (id_cliente)      REFERENCES CLIENTES(id_cliente) ON DELETE CASCADE,
  CONSTRAINT fk_av_prof  FOREIGN KEY (id_profissional) REFERENCES PROFISSIONAIS(id_profissional) ON DELETE CASCADE,
  CONSTRAINT fk_av_ag    FOREIGN KEY (id_agendamento)  REFERENCES AGENDAMENTOS(id_agendamento) ON DELETE CASCADE,
  CONSTRAINT uniq_av_cliente_ag UNIQUE (id_agendamento, id_cliente)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS RANKING (
  id_ranking      INT AUTO_INCREMENT PRIMARY KEY,
  id_profissional INT NOT NULL,
  media_nota      DECIMAL(3,2) NOT NULL,
  qtd_avaliacoes  INT NOT NULL,
  posicao         INT,
  CONSTRAINT fk_rank_prof FOREIGN KEY (id_profissional) REFERENCES PROFISSIONAIS(id_profissional) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS DENUNCIAS (
  id_denuncia       INT AUTO_INCREMENT PRIMARY KEY,
  id_agendamento    INT NOT NULL,
  id_denunciante    INT NOT NULL,  -- USUARIOS.id_usuario
  id_denunciado     INT NOT NULL,  -- USUARIOS.id_usuario
  motivo_denuncia   ENUM(
                      'Abuso/Assédio',
                      'Furto/Roubo',
                      'Agressão Física ou Verbal',
                      'Não comparecimento do Profissional',
                      'Cliente não encontrado'
                    ) NOT NULL,
  descricao_denuncia  VARCHAR(500),
  status_denuncia     ENUM('Pendente','Concluído','Cancelado','Suspensao','Banimento','Invalidada','Resolvida')
                      DEFAULT 'Pendente',
  data_denuncia       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  acao_tomada         ENUM('SUSPENDER','BANIR','INVALIDAR','DESBLOQUEAR') DEFAULT NULL,
  observacao_moderacao TEXT NULL,
  prazo_suspensao     DATE NULL,
  moderador_id        INT NULL,   -- USUARIOS.id_usuario (quem moderou)
  data_moderacao      DATETIME NULL,
  CONSTRAINT fk_den_ag         FOREIGN KEY (id_agendamento) REFERENCES AGENDAMENTOS(id_agendamento) ON DELETE CASCADE,
  CONSTRAINT fk_den_denunciante FOREIGN KEY (id_denunciante) REFERENCES USUARIOS(id_usuario),
  CONSTRAINT fk_den_denunciado  FOREIGN KEY (id_denunciado)  REFERENCES USUARIOS(id_usuario),
  CONSTRAINT fk_den_moderador   FOREIGN KEY (moderador_id)   REFERENCES USUARIOS(id_usuario),
  CONSTRAINT uniq_den_cliente_ag UNIQUE (id_agendamento, id_denunciante)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS RECUPERAR_SENHA (
  id_recuperacao  INT AUTO_INCREMENT PRIMARY KEY,
  id_usuario      INT NOT NULL,
  token           VARCHAR(255) NOT NULL UNIQUE,
  data_expiracao  DATETIME NOT NULL,
  usado           BOOLEAN DEFAULT FALSE,
  CONSTRAINT fk_rec_user FOREIGN KEY (id_usuario) REFERENCES USUARIOS(id_usuario) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS FAVORITOS (
  id_favorito     INT AUTO_INCREMENT PRIMARY KEY,
  id_cliente      INT NOT NULL,
  id_profissional INT NOT NULL,
  data_favorito   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_fav_cli  FOREIGN KEY (id_cliente)      REFERENCES CLIENTES(id_cliente) ON DELETE CASCADE,
  CONSTRAINT fk_fav_prof FOREIGN KEY (id_profissional) REFERENCES PROFISSIONAIS(id_profissional) ON DELETE CASCADE,
  CONSTRAINT uniq_fav_cli_prof UNIQUE (id_cliente, id_profissional)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS MODERACOES_DENUNCIAS (
  id_moderacao  INT AUTO_INCREMENT PRIMARY KEY,
  id_denuncia   INT NOT NULL,
  id_usuario    INT NOT NULL,  -- alvo (cliente ou profissional)
  tipo_acao     ENUM('SUSPENDER','BANIR','INVALIDAR') NOT NULL,
  observacao    TEXT NULL,
  inicio        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  fim           DATETIME NULL,
  moderador_id  INT NOT NULL,
  criado_em     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_mod_den   FOREIGN KEY (id_denuncia)  REFERENCES DENUNCIAS(id_denuncia) ON DELETE CASCADE,
  CONSTRAINT fk_mod_user  FOREIGN KEY (id_usuario)   REFERENCES USUARIOS(id_usuario)  ON DELETE CASCADE,
  CONSTRAINT fk_mod_moder FOREIGN KEY (moderador_id) REFERENCES USUARIOS(id_usuario)  ON DELETE CASCADE
) ENGINE=InnoDB;

/* SEEDS */

INSERT INTO PROFISSIONAIS (id_profissional, endereco_comercial, telefone_comercial)
SELECT u.id_usuario, NULL, '00000000000'
FROM USUARIOS u
WHERE u.tipo_usuario = 'Profissional'
  AND NOT EXISTS (SELECT 1 FROM PROFISSIONAIS p WHERE p.id_profissional = u.id_usuario);

INSERT INTO CLIENTES (id_cliente)
SELECT u.id_usuario
FROM USUARIOS u
WHERE u.tipo_usuario = 'Cliente'
  AND NOT EXISTS (SELECT 1 FROM CLIENTES c WHERE c.id_cliente = u.id_usuario);

INSERT INTO HABILIDADES (titulo, descricao, status, id_profissional)
SELECT 'Geral', 'Habilidade padrão para migração', 'Ativo', p.id_profissional
FROM PROFISSIONAIS p
LEFT JOIN HABILIDADES h
  ON h.id_profissional = p.id_profissional AND h.titulo = 'Geral'
WHERE h.id_habilidade IS NULL;

UPDATE AGENDAMENTOS ag
JOIN HABILIDADES h
  ON h.id_profissional = ag.id_profissional AND h.titulo = 'Geral'
SET ag.id_habilidade = h.id_habilidade
WHERE ag.id_habilidade IS NULL;


