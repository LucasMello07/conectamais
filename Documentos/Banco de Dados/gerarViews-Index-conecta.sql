use conecta;

CREATE OR REPLACE VIEW vw_ranking_profissionais AS
SELECT
  p.id_profissional,
  ROUND(AVG(CASE a.nota
              WHEN 'Ruim'      THEN 1
              WHEN 'Regular'   THEN 2
              WHEN 'Bom'       THEN 3
              WHEN 'Ótimo'     THEN 4
              WHEN 'Excelente' THEN 5
            END), 2)                            AS media_nota,
  COUNT(a.id_avaliacao)                         AS qtd_avaliacoes,
  DENSE_RANK() OVER (
    ORDER BY
      AVG(CASE a.nota
             WHEN 'Ruim'      THEN 1
             WHEN 'Regular'   THEN 2
             WHEN 'Bom'       THEN 3
             WHEN 'Ótimo'     THEN 4
             WHEN 'Excelente' THEN 5
          END) DESC,
      COUNT(a.id_avaliacao) DESC
  )                                             AS posicao
FROM PROFISSIONAIS p
LEFT JOIN AVALIACOES a ON a.id_profissional = p.id_profissional
GROUP BY p.id_profissional;


CREATE OR REPLACE VIEW vw_favoritos_profissional AS
SELECT
  f.id_profissional,
  COUNT(*) AS qtd_favoritos
FROM FAVORITOS f
GROUP BY f.id_profissional;

DROP VIEW IF EXISTS vw_denuncias_listagem;
CREATE VIEW vw_denuncias_listagem AS
SELECT
  d.id_denuncia,
  d.status_denuncia,
  d.motivo_denuncia,
  d.data_denuncia,
  ucli.nome_completo  AS cliente_nome,
  uprof.nome_completo AS profissional_nome
FROM DENUNCIAS d
JOIN AGENDAMENTOS ag    ON ag.id_agendamento = d.id_agendamento
JOIN CLIENTES c         ON c.id_cliente = ag.id_cliente
JOIN PROFISSIONAIS p    ON p.id_profissional = ag.id_profissional
JOIN USUARIOS ucli      ON ucli.id_usuario = c.id_cliente
JOIN USUARIOS uprof     ON uprof.id_usuario = p.id_profissional
ORDER BY d.data_denuncia DESC;

DROP VIEW IF EXISTS vw_denuncia_detalhe;
CREATE VIEW vw_denuncia_detalhe AS
SELECT
  d.id_denuncia,
  d.id_agendamento,
  d.id_denunciante,
  d.id_denunciado,
  d.motivo_denuncia,
  d.descricao_denuncia,
  d.status_denuncia,
  d.data_denuncia,
  d.acao_tomada,
  d.observacao_moderacao,
  d.prazo_suspensao,
  d.moderador_id,
  d.data_moderacao,
  ucli.id_usuario       AS cliente_id_usuario,
  ucli.nome_completo    AS cliente_nome,
  ucli.email            AS cliente_email,
  uprof.id_usuario      AS profissional_id_usuario,
  uprof.nome_completo   AS profissional_nome,
  uprof.email           AS profissional_email
FROM DENUNCIAS d
JOIN AGENDAMENTOS ag    ON ag.id_agendamento = d.id_agendamento
JOIN CLIENTES c         ON c.id_cliente = ag.id_cliente
JOIN PROFISSIONAIS p    ON p.id_profissional = ag.id_profissional
JOIN USUARIOS ucli      ON ucli.id_usuario = c.id_cliente
JOIN USUARIOS uprof     ON uprof.id_usuario = p.id_profissional;

CREATE INDEX idx_avaliacoes_prof_data ON AVALIACOES (id_profissional, data_avaliacao DESC);
  
CREATE INDEX idx_usuarios_status ON USUARIOS(status_usuario);

CREATE INDEX idx_denuncias_status ON DENUNCIAS(status_denuncia);

CREATE INDEX idx_denuncias_data ON DENUNCIAS(data_denuncia);

CREATE INDEX idx_ag_cli_status ON AGENDAMENTOS (id_cliente, status_agendamento);

CREATE INDEX idx_ag_prof_status ON AGENDAMENTOS (id_profissional, status_agendamento);

CREATE INDEX idx_ag_prof_data_hora  ON AGENDAMENTOS (id_profissional, data_agendamento, horario_agendamento);

CREATE INDEX idx_hab_prof_status ON HABILIDADES (id_profissional, status);

CREATE INDEX idx_av_ag_cli ON AVALIACOES (id_agendamento, id_cliente);

CREATE INDEX idx_den_ag_denunciante ON DENUNCIAS (id_agendamento, id_denunciante);
  
CREATE INDEX idx_mod_user ON MODERACOES_DENUNCIAS(id_usuario, tipo_acao);

CREATE INDEX idx_mod_den ON MODERACOES_DENUNCIAS(id_denuncia);

CREATE INDEX idx_mod_inicio ON MODERACOES_DENUNCIAS(inicio);
