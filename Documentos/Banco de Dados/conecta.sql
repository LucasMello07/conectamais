-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 19/11/2025 às 14:00
-- Versão do servidor: 10.4.32-MariaDB
-- Versão do PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `conecta`
--

-- --------------------------------------------------------

--
-- Estrutura para tabela `administrador`
--

CREATE TABLE `administrador` (
  `id_admin` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `administrador`
--

INSERT INTO `administrador` (`id_admin`) VALUES
(5);

-- --------------------------------------------------------

--
-- Estrutura para tabela `agendamentos`
--

CREATE TABLE `agendamentos` (
  `id_agendamento` int(11) NOT NULL,
  `id_cliente` int(11) NOT NULL,
  `id_profissional` int(11) NOT NULL,
  `data_agendamento` date NOT NULL,
  `horario_agendamento` time NOT NULL,
  `status_agendamento` enum('Pendente','Concluído','Cancelado') DEFAULT 'Pendente',
  `id_habilidade` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `agendamentos`
--

INSERT INTO `agendamentos` (`id_agendamento`, `id_cliente`, `id_profissional`, `data_agendamento`, `horario_agendamento`, `status_agendamento`, `id_habilidade`) VALUES
(1, 1, 2, '2025-09-18', '22:00:00', 'Concluído', 2),
(2, 1, 2, '2025-09-20', '13:00:00', 'Cancelado', 2),
(3, 1, 2, '2025-09-20', '17:00:00', 'Concluído', 2),
(4, 1, 2, '2025-09-22', '15:00:00', 'Concluído', 2),
(5, 1, 2, '2025-09-22', '20:00:00', 'Concluído', 2),
(6, 1, 2, '2025-09-24', '17:00:00', 'Concluído', 2);

-- --------------------------------------------------------

--
-- Estrutura para tabela `avaliacoes`
--

CREATE TABLE `avaliacoes` (
  `id_avaliacao` int(11) NOT NULL,
  `id_cliente` int(11) NOT NULL,
  `id_profissional` int(11) NOT NULL,
  `id_agendamento` int(11) NOT NULL,
  `nota` enum('Ruim','Regular','Bom','Ótimo','Excelente') NOT NULL,
  `comentario_avaliacao` varchar(500) DEFAULT NULL,
  `data_avaliacao` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `avaliacoes`
--

INSERT INTO `avaliacoes` (`id_avaliacao`, `id_cliente`, `id_profissional`, `id_agendamento`, `nota`, `comentario_avaliacao`, `data_avaliacao`) VALUES
(1, 1, 2, 1, 'Excelente', 'Testando sistema de avaliação', '2025-09-18 00:00:00'),
(4, 1, 2, 6, 'Ruim', 'otimo!', '2025-09-24 00:00:00');

-- --------------------------------------------------------

--
-- Estrutura para tabela `clientes`
--

CREATE TABLE `clientes` (
  `id_cliente` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `clientes`
--

INSERT INTO `clientes` (`id_cliente`) VALUES
(1),
(8);

-- --------------------------------------------------------

--
-- Estrutura para tabela `denuncias`
--

CREATE TABLE `denuncias` (
  `id_denuncia` int(11) NOT NULL,
  `id_agendamento` int(11) NOT NULL,
  `id_denunciante` int(11) NOT NULL,
  `id_denunciado` int(11) NOT NULL,
  `motivo_denuncia` enum('Abuso/Assédio','Furto/Roubo','Agressão Física ou Verbal','Não comparecimento do Profissional','Cliente não encontrado') NOT NULL,
  `descricao_denuncia` varchar(500) DEFAULT NULL,
  `status_denuncia` enum('Pendente','Concluído','Cancelado','Suspensao','Banimento','Invalidada','Resolvida') DEFAULT 'Pendente',
  `data_denuncia` datetime NOT NULL DEFAULT current_timestamp(),
  `acao_tomada` enum('SUSPENDER','BANIR','INVALIDAR','DESBLOQUEAR') DEFAULT NULL,
  `observacao_moderacao` text DEFAULT NULL,
  `prazo_suspensao` date DEFAULT NULL,
  `moderador_id` int(11) DEFAULT NULL,
  `data_moderacao` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `denuncias`
--

INSERT INTO `denuncias` (`id_denuncia`, `id_agendamento`, `id_denunciante`, `id_denunciado`, `motivo_denuncia`, `descricao_denuncia`, `status_denuncia`, `data_denuncia`, `acao_tomada`, `observacao_moderacao`, `prazo_suspensao`, `moderador_id`, `data_moderacao`) VALUES
(1, 1, 1, 2, 'Não comparecimento do Profissional', 'teste de denuncia', 'Resolvida', '2025-09-22 16:07:18', 'DESBLOQUEAR', 'teste de suspensão', '2025-09-23', 5, '2025-09-24 16:44:57'),
(2, 6, 1, 2, 'Não comparecimento do Profissional', 'teste denuncia', 'Resolvida', '2025-09-24 16:42:05', 'DESBLOQUEAR', 'teste de moderação', '2025-09-28', 5, '2025-09-24 16:44:57');

-- --------------------------------------------------------

--
-- Estrutura para tabela `favoritos`
--

CREATE TABLE `favoritos` (
  `id_favorito` int(11) NOT NULL,
  `id_cliente` int(11) NOT NULL,
  `id_profissional` int(11) NOT NULL,
  `data_favorito` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `favoritos`
--

INSERT INTO `favoritos` (`id_favorito`, `id_cliente`, `id_profissional`, `data_favorito`) VALUES
(1, 1, 2, '2025-09-19 00:24:54'),
(2, 1, 3, '2025-09-19 00:24:54');

-- --------------------------------------------------------

--
-- Estrutura para tabela `habilidades`
--

CREATE TABLE `habilidades` (
  `id_habilidade` int(11) NOT NULL,
  `titulo` varchar(255) NOT NULL,
  `descricao` varchar(50) NOT NULL,
  `status` varchar(50) NOT NULL DEFAULT 'Ativo',
  `id_profissional` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `habilidades`
--

INSERT INTO `habilidades` (`id_habilidade`, `titulo`, `descricao`, `status`, `id_profissional`) VALUES
(1, 'Barbearia', 'Corte masculino clássico e moderno', 'Ativo', 2),
(2, 'Barba', 'Barba completa e design', 'Ativo', 2),
(3, 'Cabeleireira', 'Corte feminino e coloração', 'Ativo', 3),
(4, 'Penteados', 'Penteados para eventos', 'Ativo', 3),
(5, 'Sobrancelhas', 'Design de sobrancelhas', 'Ativo', 4),
(6, 'Visagismo', 'Visagismo básico', 'Ativo', 4),
(7, 'teste', 'descrição', 'Ativo', 2);

-- --------------------------------------------------------

--
-- Estrutura para tabela `moderacoes_denuncias`
--

CREATE TABLE `moderacoes_denuncias` (
  `id_moderacao` int(11) NOT NULL,
  `id_denuncia` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `tipo_acao` enum('SUSPENDER','BANIR','INVALIDAR') NOT NULL,
  `observacao` text DEFAULT NULL,
  `inicio` datetime NOT NULL DEFAULT current_timestamp(),
  `fim` datetime DEFAULT NULL,
  `moderador_id` int(11) NOT NULL,
  `criado_em` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `moderacoes_denuncias`
--

INSERT INTO `moderacoes_denuncias` (`id_moderacao`, `id_denuncia`, `id_usuario`, `tipo_acao`, `observacao`, `inicio`, `fim`, `moderador_id`, `criado_em`) VALUES
(1, 1, 2, 'SUSPENDER', 'teste de suspensão', '2025-09-22 16:08:06', '2025-09-23 00:00:00', 5, '2025-09-22 16:08:06'),
(2, 1, 2, 'SUSPENDER', 'teste de suspensão', '2025-09-22 16:08:07', '2025-09-23 00:00:00', 5, '2025-09-22 16:08:07'),
(3, 2, 2, 'SUSPENDER', 'teste de moderação', '2025-09-24 16:43:34', '2025-09-28 00:00:00', 5, '2025-09-24 16:43:34');

-- --------------------------------------------------------

--
-- Estrutura para tabela `profissionais`
--

CREATE TABLE `profissionais` (
  `id_profissional` int(11) NOT NULL,
  `endereco_comercial` varchar(100) DEFAULT NULL,
  `telefone_comercial` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `profissionais`
--

INSERT INTO `profissionais` (`id_profissional`, `endereco_comercial`, `telefone_comercial`) VALUES
(2, 'Sala 101 - Centro/SP', '11970000001'),
(3, 'Studio 22 - Copacabana/RJ', '21970000002'),
(4, 'Cowork 5 - Savassi/MG', '31970000003');

-- --------------------------------------------------------

--
-- Estrutura para tabela `ranking`
--

CREATE TABLE `ranking` (
  `id_ranking` int(11) NOT NULL,
  `id_profissional` int(11) NOT NULL,
  `media_nota` decimal(3,2) NOT NULL,
  `qtd_avaliacoes` int(11) NOT NULL,
  `posicao` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `recuperar_senha`
--

CREATE TABLE `recuperar_senha` (
  `id_recuperacao` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `token` varchar(255) NOT NULL,
  `data_expiracao` datetime NOT NULL,
  `usado` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `recuperar_senha`
--

INSERT INTO `recuperar_senha` (`id_recuperacao`, `id_usuario`, `token`, `data_expiracao`, `usado`) VALUES
(1, 6, 'c5413361-32d5-45ff-9d7c-4554e978787e', '2025-09-22 14:32:55', 0),
(2, 6, 'f12f3b5c-1a09-4d93-9d43-e20842ab99e1', '2025-09-22 16:39:04', 0),
(3, 6, 'cc155830-1d4e-4d21-ab49-8cdc8919c1a1', '2025-09-22 17:01:02', 0),
(4, 6, '2100a174-2f7b-46dc-8cf0-25911832a802', '2025-09-22 17:26:25', 0),
(5, 6, '5159a640-c2cd-414d-8271-90a1f1b75154', '2025-09-22 17:26:36', 0),
(6, 6, 'df92bcde-e779-47ec-9805-e27b106e55b9', '2025-09-22 17:51:37', 0),
(7, 6, '7db408ba-0861-4216-b48d-d97a9be1d49c', '2025-09-22 17:55:46', 0),
(8, 6, '972ebba9-8bf6-4770-8ea6-26b297d31395', '2025-09-22 18:11:56', 0),
(9, 6, '42275aff-55bd-4461-a2ed-aadd0e130013', '2025-09-22 18:13:55', 0),
(10, 6, '41e3051e-0d16-4c7d-8ab2-fe23cde14c6e', '2025-09-22 18:15:30', 0),
(11, 6, 'edcc7a98-c9de-45db-8bd2-2a82886a6ca4', '2025-09-22 18:47:27', 0),
(12, 6, '52e19546-2cae-4c24-bab2-a4e0368acdb5', '2025-09-22 19:02:52', 0),
(13, 2, '8ce5469dbffe41c8a2169df1633c2d62', '2025-09-24 18:13:03', 0);

-- --------------------------------------------------------

--
-- Estrutura para tabela `usuarios`
--

CREATE TABLE `usuarios` (
  `id_usuario` int(11) NOT NULL,
  `nome_completo` varchar(100) NOT NULL,
  `data_nascimento` date NOT NULL,
  `genero` enum('Masculino','Feminino','Prefiro não dizer') NOT NULL,
  `celular` varchar(11) NOT NULL,
  `email` varchar(100) NOT NULL,
  `senha` varchar(255) NOT NULL,
  `cpf_cnpj` varchar(15) NOT NULL,
  `endereco_rua` varchar(100) NOT NULL,
  `bairro` varchar(50) NOT NULL,
  `cidade` varchar(50) NOT NULL,
  `estado` char(2) NOT NULL,
  `tipo_usuario` enum('Cliente','Profissional','Administrador') NOT NULL,
  `status_usuario` enum('ATIVO','SUSPENSO','BANIDO') DEFAULT 'ATIVO'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `usuarios`
--

INSERT INTO `usuarios` (`id_usuario`, `nome_completo`, `data_nascimento`, `genero`, `celular`, `email`, `senha`, `cpf_cnpj`, `endereco_rua`, `bairro`, `cidade`, `estado`, `tipo_usuario`, `status_usuario`) VALUES
(1, 'Cliente Demo', '1995-05-20', 'Prefiro não dizer', '11999990000', 'cliente@conecta.com', '123456', '12345678900', 'Rua das Flores, 100', 'Centro', 'São Paulo', 'SP', 'Cliente', 'ATIVO'),
(2, 'TESTE PROFISSIONAL', '1990-01-10', 'Masculino', '11912345678', 'joao@conecta.com', '123456', '11111111111', 'Rua Alfa, 10', 'Centro', 'São Paulo', 'SP', 'Profissional', 'ATIVO'),
(3, 'Maria Cabelereira', '1988-03-22', 'Feminino', '21988880002', 'maria@conecta.com', '123', '22222222222', 'Av. Beta, 200', 'Copacabana', 'Rio de Janeiro', 'RJ', 'Profissional', 'ATIVO'),
(4, 'Pedro Designer', '1992-07-15', 'Masculino', '31988880003', 'pedro@conecta.com', '123', '33333333333', 'Rua Gama, 300', 'Savassi', 'Belo Horizonte', 'MG', 'Profissional', 'ATIVO'),
(5, 'Vinicius Rodrigues', '2003-01-01', 'Prefiro não dizer', '11999990001', 'adm@conecta.com.br', '123', '00000000000', 'Rua Projetada, 123', 'Centro', 'São Paulo', 'SP', 'Administrador', 'ATIVO'),
(6, 'Vinicius Rodrigues', '2003-01-08', 'Masculino', '19989192662', 'vinicius.correia0801@gmail.com', '123', '51912114801', 'Rua Teste, 123', 'Centro', 'São Paulo', 'SP', 'Profissional', 'ATIVO'),
(8, 'Cliente Teste Recuperacao', '1990-01-01', 'Prefiro não dizer', '11999999999', 'digehix192@dawhe.com', '123', '12312345677', 'Rua Teste, 123', 'Bairro Teste', 'Cidade Teste', 'SP', 'Cliente', 'ATIVO');

-- --------------------------------------------------------

--
-- Estrutura stand-in para view `vw_denuncias_listagem`
-- (Veja abaixo para a visão atual)
--
CREATE TABLE `vw_denuncias_listagem` (
`id_denuncia` int(11)
,`status_denuncia` enum('Pendente','Concluído','Cancelado','Suspensao','Banimento','Invalidada','Resolvida')
,`motivo_denuncia` enum('Abuso/Assédio','Furto/Roubo','Agressão Física ou Verbal','Não comparecimento do Profissional','Cliente não encontrado')
,`data_denuncia` datetime
,`cliente_nome` varchar(100)
,`profissional_nome` varchar(100)
);

-- --------------------------------------------------------

--
-- Estrutura stand-in para view `vw_denuncia_detalhe`
-- (Veja abaixo para a visão atual)
--
CREATE TABLE `vw_denuncia_detalhe` (
`id_denuncia` int(11)
,`id_agendamento` int(11)
,`id_denunciante` int(11)
,`id_denunciado` int(11)
,`motivo_denuncia` enum('Abuso/Assédio','Furto/Roubo','Agressão Física ou Verbal','Não comparecimento do Profissional','Cliente não encontrado')
,`descricao_denuncia` varchar(500)
,`status_denuncia` enum('Pendente','Concluído','Cancelado','Suspensao','Banimento','Invalidada','Resolvida')
,`data_denuncia` datetime
,`acao_tomada` enum('SUSPENDER','BANIR','INVALIDAR','DESBLOQUEAR')
,`observacao_moderacao` text
,`prazo_suspensao` date
,`moderador_id` int(11)
,`data_moderacao` datetime
,`cliente_id_usuario` int(11)
,`cliente_nome` varchar(100)
,`cliente_email` varchar(100)
,`profissional_id_usuario` int(11)
,`profissional_nome` varchar(100)
,`profissional_email` varchar(100)
);

-- --------------------------------------------------------

--
-- Estrutura stand-in para view `vw_favoritos_profissional`
-- (Veja abaixo para a visão atual)
--
CREATE TABLE `vw_favoritos_profissional` (
`id_profissional` int(11)
,`qtd_favoritos` bigint(21)
);

-- --------------------------------------------------------

--
-- Estrutura stand-in para view `vw_ranking_profissionais`
-- (Veja abaixo para a visão atual)
--
CREATE TABLE `vw_ranking_profissionais` (
`id_profissional` int(11)
,`media_nota` decimal(3,2)
,`qtd_avaliacoes` bigint(21)
,`posicao` bigint(21)
);

-- --------------------------------------------------------

--
-- Estrutura para view `vw_denuncias_listagem`
--
DROP TABLE IF EXISTS `vw_denuncias_listagem`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_denuncias_listagem`  AS SELECT `d`.`id_denuncia` AS `id_denuncia`, `d`.`status_denuncia` AS `status_denuncia`, `d`.`motivo_denuncia` AS `motivo_denuncia`, `d`.`data_denuncia` AS `data_denuncia`, `ucli`.`nome_completo` AS `cliente_nome`, `uprof`.`nome_completo` AS `profissional_nome` FROM (((((`denuncias` `d` join `agendamentos` `ag` on(`ag`.`id_agendamento` = `d`.`id_agendamento`)) join `clientes` `c` on(`c`.`id_cliente` = `ag`.`id_cliente`)) join `profissionais` `p` on(`p`.`id_profissional` = `ag`.`id_profissional`)) join `usuarios` `ucli` on(`ucli`.`id_usuario` = `c`.`id_cliente`)) join `usuarios` `uprof` on(`uprof`.`id_usuario` = `p`.`id_profissional`)) ORDER BY `d`.`data_denuncia` DESC ;

-- --------------------------------------------------------

--
-- Estrutura para view `vw_denuncia_detalhe`
--
DROP TABLE IF EXISTS `vw_denuncia_detalhe`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_denuncia_detalhe`  AS SELECT `d`.`id_denuncia` AS `id_denuncia`, `d`.`id_agendamento` AS `id_agendamento`, `d`.`id_denunciante` AS `id_denunciante`, `d`.`id_denunciado` AS `id_denunciado`, `d`.`motivo_denuncia` AS `motivo_denuncia`, `d`.`descricao_denuncia` AS `descricao_denuncia`, `d`.`status_denuncia` AS `status_denuncia`, `d`.`data_denuncia` AS `data_denuncia`, `d`.`acao_tomada` AS `acao_tomada`, `d`.`observacao_moderacao` AS `observacao_moderacao`, `d`.`prazo_suspensao` AS `prazo_suspensao`, `d`.`moderador_id` AS `moderador_id`, `d`.`data_moderacao` AS `data_moderacao`, `ucli`.`id_usuario` AS `cliente_id_usuario`, `ucli`.`nome_completo` AS `cliente_nome`, `ucli`.`email` AS `cliente_email`, `uprof`.`id_usuario` AS `profissional_id_usuario`, `uprof`.`nome_completo` AS `profissional_nome`, `uprof`.`email` AS `profissional_email` FROM (((((`denuncias` `d` join `agendamentos` `ag` on(`ag`.`id_agendamento` = `d`.`id_agendamento`)) join `clientes` `c` on(`c`.`id_cliente` = `ag`.`id_cliente`)) join `profissionais` `p` on(`p`.`id_profissional` = `ag`.`id_profissional`)) join `usuarios` `ucli` on(`ucli`.`id_usuario` = `c`.`id_cliente`)) join `usuarios` `uprof` on(`uprof`.`id_usuario` = `p`.`id_profissional`)) ;

-- --------------------------------------------------------

--
-- Estrutura para view `vw_favoritos_profissional`
--
DROP TABLE IF EXISTS `vw_favoritos_profissional`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_favoritos_profissional`  AS SELECT `f`.`id_profissional` AS `id_profissional`, count(0) AS `qtd_favoritos` FROM `favoritos` AS `f` GROUP BY `f`.`id_profissional` ;

-- --------------------------------------------------------

--
-- Estrutura para view `vw_ranking_profissionais`
--
DROP TABLE IF EXISTS `vw_ranking_profissionais`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_ranking_profissionais`  AS SELECT `p`.`id_profissional` AS `id_profissional`, round(avg(case `a`.`nota` when 'Ruim' then 1 when 'Regular' then 2 when 'Bom' then 3 when 'Ótimo' then 4 when 'Excelente' then 5 end),2) AS `media_nota`, count(`a`.`id_avaliacao`) AS `qtd_avaliacoes`, dense_rank() over ( order by avg(case `a`.`nota` when 'Ruim' then 1 when 'Regular' then 2 when 'Bom' then 3 when 'Ótimo' then 4 when 'Excelente' then 5 end) desc,count(`a`.`id_avaliacao`) desc) AS `posicao` FROM (`profissionais` `p` left join `avaliacoes` `a` on(`a`.`id_profissional` = `p`.`id_profissional`)) GROUP BY `p`.`id_profissional` ;

--
-- Índices para tabelas despejadas
--

--
-- Índices de tabela `administrador`
--
ALTER TABLE `administrador`
  ADD PRIMARY KEY (`id_admin`);

--
-- Índices de tabela `agendamentos`
--
ALTER TABLE `agendamentos`
  ADD PRIMARY KEY (`id_agendamento`),
  ADD KEY `fk_ag_habilidade` (`id_habilidade`),
  ADD KEY `idx_ag_cli_status` (`id_cliente`,`status_agendamento`),
  ADD KEY `idx_ag_prof_status` (`id_profissional`,`status_agendamento`),
  ADD KEY `idx_ag_prof_data_hora` (`id_profissional`,`data_agendamento`,`horario_agendamento`),
  ADD KEY `idx_ag_prof_data_time` (`id_profissional`,`data_agendamento`,`horario_agendamento`);

--
-- Índices de tabela `avaliacoes`
--
ALTER TABLE `avaliacoes`
  ADD PRIMARY KEY (`id_avaliacao`),
  ADD UNIQUE KEY `uniq_av_cliente_ag` (`id_agendamento`,`id_cliente`),
  ADD KEY `fk_av_cli` (`id_cliente`),
  ADD KEY `idx_avaliacoes_prof_data` (`id_profissional`,`data_avaliacao`),
  ADD KEY `idx_av_ag_cli` (`id_agendamento`,`id_cliente`);

--
-- Índices de tabela `clientes`
--
ALTER TABLE `clientes`
  ADD PRIMARY KEY (`id_cliente`);

--
-- Índices de tabela `denuncias`
--
ALTER TABLE `denuncias`
  ADD PRIMARY KEY (`id_denuncia`),
  ADD UNIQUE KEY `uniq_den_cliente_ag` (`id_agendamento`,`id_denunciante`),
  ADD KEY `fk_den_denunciante` (`id_denunciante`),
  ADD KEY `fk_den_denunciado` (`id_denunciado`),
  ADD KEY `fk_den_moderador` (`moderador_id`),
  ADD KEY `idx_denuncias_status` (`status_denuncia`),
  ADD KEY `idx_denuncias_data` (`data_denuncia`),
  ADD KEY `idx_den_ag_denunciante` (`id_agendamento`,`id_denunciante`);

--
-- Índices de tabela `favoritos`
--
ALTER TABLE `favoritos`
  ADD PRIMARY KEY (`id_favorito`),
  ADD UNIQUE KEY `uniq_fav_cli_prof` (`id_cliente`,`id_profissional`),
  ADD KEY `fk_fav_prof` (`id_profissional`);

--
-- Índices de tabela `habilidades`
--
ALTER TABLE `habilidades`
  ADD PRIMARY KEY (`id_habilidade`),
  ADD KEY `idx_hab_prof_status` (`id_profissional`,`status`);

--
-- Índices de tabela `moderacoes_denuncias`
--
ALTER TABLE `moderacoes_denuncias`
  ADD PRIMARY KEY (`id_moderacao`),
  ADD KEY `fk_mod_moder` (`moderador_id`),
  ADD KEY `idx_mod_user` (`id_usuario`,`tipo_acao`),
  ADD KEY `idx_mod_den` (`id_denuncia`),
  ADD KEY `idx_mod_inicio` (`inicio`);

--
-- Índices de tabela `profissionais`
--
ALTER TABLE `profissionais`
  ADD PRIMARY KEY (`id_profissional`);

--
-- Índices de tabela `ranking`
--
ALTER TABLE `ranking`
  ADD PRIMARY KEY (`id_ranking`),
  ADD KEY `fk_rank_prof` (`id_profissional`);

--
-- Índices de tabela `recuperar_senha`
--
ALTER TABLE `recuperar_senha`
  ADD PRIMARY KEY (`id_recuperacao`),
  ADD UNIQUE KEY `token` (`token`),
  ADD KEY `fk_rec_user` (`id_usuario`);

--
-- Índices de tabela `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id_usuario`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `cpf_cnpj` (`cpf_cnpj`),
  ADD KEY `idx_usuarios_status` (`status_usuario`);

--
-- AUTO_INCREMENT para tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `agendamentos`
--
ALTER TABLE `agendamentos`
  MODIFY `id_agendamento` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de tabela `avaliacoes`
--
ALTER TABLE `avaliacoes`
  MODIFY `id_avaliacao` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de tabela `denuncias`
--
ALTER TABLE `denuncias`
  MODIFY `id_denuncia` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de tabela `favoritos`
--
ALTER TABLE `favoritos`
  MODIFY `id_favorito` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de tabela `habilidades`
--
ALTER TABLE `habilidades`
  MODIFY `id_habilidade` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de tabela `moderacoes_denuncias`
--
ALTER TABLE `moderacoes_denuncias`
  MODIFY `id_moderacao` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de tabela `ranking`
--
ALTER TABLE `ranking`
  MODIFY `id_ranking` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `recuperar_senha`
--
ALTER TABLE `recuperar_senha`
  MODIFY `id_recuperacao` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT de tabela `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id_usuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- Restrições para tabelas despejadas
--

--
-- Restrições para tabelas `administrador`
--
ALTER TABLE `administrador`
  ADD CONSTRAINT `fk_admin_usuario` FOREIGN KEY (`id_admin`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE;

--
-- Restrições para tabelas `agendamentos`
--
ALTER TABLE `agendamentos`
  ADD CONSTRAINT `fk_ag_cliente` FOREIGN KEY (`id_cliente`) REFERENCES `clientes` (`id_cliente`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_ag_habilidade` FOREIGN KEY (`id_habilidade`) REFERENCES `habilidades` (`id_habilidade`),
  ADD CONSTRAINT `fk_ag_profissional` FOREIGN KEY (`id_profissional`) REFERENCES `profissionais` (`id_profissional`) ON DELETE CASCADE;

--
-- Restrições para tabelas `avaliacoes`
--
ALTER TABLE `avaliacoes`
  ADD CONSTRAINT `fk_av_ag` FOREIGN KEY (`id_agendamento`) REFERENCES `agendamentos` (`id_agendamento`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_av_cli` FOREIGN KEY (`id_cliente`) REFERENCES `clientes` (`id_cliente`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_av_prof` FOREIGN KEY (`id_profissional`) REFERENCES `profissionais` (`id_profissional`) ON DELETE CASCADE;

--
-- Restrições para tabelas `clientes`
--
ALTER TABLE `clientes`
  ADD CONSTRAINT `fk_clientes_usuario` FOREIGN KEY (`id_cliente`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE;

--
-- Restrições para tabelas `denuncias`
--
ALTER TABLE `denuncias`
  ADD CONSTRAINT `fk_den_ag` FOREIGN KEY (`id_agendamento`) REFERENCES `agendamentos` (`id_agendamento`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_den_denunciado` FOREIGN KEY (`id_denunciado`) REFERENCES `usuarios` (`id_usuario`),
  ADD CONSTRAINT `fk_den_denunciante` FOREIGN KEY (`id_denunciante`) REFERENCES `usuarios` (`id_usuario`),
  ADD CONSTRAINT `fk_den_moderador` FOREIGN KEY (`moderador_id`) REFERENCES `usuarios` (`id_usuario`);

--
-- Restrições para tabelas `favoritos`
--
ALTER TABLE `favoritos`
  ADD CONSTRAINT `fk_fav_cli` FOREIGN KEY (`id_cliente`) REFERENCES `clientes` (`id_cliente`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_fav_prof` FOREIGN KEY (`id_profissional`) REFERENCES `profissionais` (`id_profissional`) ON DELETE CASCADE;

--
-- Restrições para tabelas `habilidades`
--
ALTER TABLE `habilidades`
  ADD CONSTRAINT `fk_hab_prof` FOREIGN KEY (`id_profissional`) REFERENCES `profissionais` (`id_profissional`) ON DELETE CASCADE;

--
-- Restrições para tabelas `moderacoes_denuncias`
--
ALTER TABLE `moderacoes_denuncias`
  ADD CONSTRAINT `fk_mod_den` FOREIGN KEY (`id_denuncia`) REFERENCES `denuncias` (`id_denuncia`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_mod_moder` FOREIGN KEY (`moderador_id`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_mod_user` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE;

--
-- Restrições para tabelas `profissionais`
--
ALTER TABLE `profissionais`
  ADD CONSTRAINT `fk_profissionais_usuario` FOREIGN KEY (`id_profissional`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE;

--
-- Restrições para tabelas `ranking`
--
ALTER TABLE `ranking`
  ADD CONSTRAINT `fk_rank_prof` FOREIGN KEY (`id_profissional`) REFERENCES `profissionais` (`id_profissional`) ON DELETE CASCADE;

--
-- Restrições para tabelas `recuperar_senha`
--
ALTER TABLE `recuperar_senha`
  ADD CONSTRAINT `fk_rec_user` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
