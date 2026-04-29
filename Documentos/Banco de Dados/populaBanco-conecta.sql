USE conecta;

INSERT INTO USUARIOS
  (nome_completo, data_nascimento, genero, celular, email, senha,
   cpf_cnpj, endereco_rua, bairro, cidade, estado, tipo_usuario)
VALUES
  ('Cliente Demo', '1995-05-20', 'Prefiro não dizer', '11999990000', 'cliente@conecta.com', '123',
   '12345678900', 'Rua das Flores, 100', 'Centro', 'São Paulo', 'SP', 'Cliente');

INSERT INTO CLIENTES (id_cliente)
SELECT id_usuario FROM USUARIOS WHERE email='cliente@conecta.com' LIMIT 1;

INSERT INTO USUARIOS
  (nome_completo, data_nascimento, genero, celular, email, senha,
   cpf_cnpj, endereco_rua, bairro, cidade, estado, tipo_usuario)
VALUES
  ('João Barbeiro',   '1990-01-10', 'Masculino', '11988880001', 'joao@conecta.com', '123',
   '11111111111', 'Rua Alfa, 10',  'Centro', 'São Paulo', 'SP', 'Profissional'),
  ('Maria Cabelereira','1988-03-22','Feminino',  '21988880002', 'maria@conecta.com', '123',
   '22222222222', 'Av. Beta, 200', 'Copacabana','Rio de Janeiro','RJ','Profissional'),
  ('Pedro Designer',   '1992-07-15','Masculino', '31988880003', 'pedro@conecta.com', '123',
   '33333333333', 'Rua Gama, 300', 'Savassi', 'Belo Horizonte', 'MG', 'Profissional');

SET @idProf1 = (SELECT id_usuario FROM USUARIOS WHERE email='joao@conecta.com'   LIMIT 1);
SET @idProf2 = (SELECT id_usuario FROM USUARIOS WHERE email='maria@conecta.com'  LIMIT 1);
SET @idProf3 = (SELECT id_usuario FROM USUARIOS WHERE email='pedro@conecta.com'  LIMIT 1);

INSERT INTO PROFISSIONAIS (id_profissional, endereco_comercial, telefone_comercial) VALUES
(@idProf1, 'Sala 101 - Centro/SP', '11970000001'),
(@idProf2, 'Studio 22 - Copacabana/RJ', '21970000002'),
(@idProf3, 'Cowork 5 - Savassi/MG', '31970000003');

INSERT INTO HABILIDADES (descricao, id_profissional, titulo, status) VALUES
('Corte masculino clássico e moderno', @idProf1, 'Barbearia', 'Ativo'),
('Barba completa e design',            @idProf1, 'Barba', 'Ativo'),
('Corte feminino e coloração',         @idProf2, 'Cabeleireira', 'Ativo'),
('Penteados para eventos',             @idProf2, 'Penteados', 'Ativo'),
('Design de sobrancelhas',             @idProf3, 'Sobrancelhas', 'Ativo'),
('Visagismo básico',                   @idProf3, 'Visagismo', 'Ativo');

SET @idCliente = (SELECT c.id_cliente
                  FROM CLIENTES c
                  JOIN USUARIOS u ON u.id_usuario = c.id_cliente
                 WHERE u.email='cliente@conecta.com'
                 LIMIT 1);

INSERT INTO FAVORITOS (id_cliente, id_profissional, data_favorito) VALUES
(@idCliente, @idProf1, NOW()),
(@idCliente, @idProf2, NOW());

INSERT INTO USUARIOS
  (nome_completo, data_nascimento, genero, celular, email, senha,
   cpf_cnpj, endereco_rua, bairro, cidade, estado, tipo_usuario)
VALUES
  ('Vinicius Rodrigues', '2003-01-01', 'Prefiro não dizer', '11999990001', 'adm@conecta.com.br', '123',
   '00000000000', 'Rua Projetada, 123', 'Centro', 'São Paulo', 'SP', 'Administrador');

SET @idAdm = (SELECT id_usuario
                FROM USUARIOS
               WHERE email='adm@conecta.com.br'
               LIMIT 1);
               
INSERT INTO ADMINISTRADOR (id_admin) VALUES (@idAdm);


-- cria o usuário base
INSERT INTO USUARIOS
  (nome_completo, data_nascimento, genero, celular, email, senha,
   cpf_cnpj, endereco_rua, bairro, cidade, estado, tipo_usuario)
VALUES
  ('Vinicius Rodrigues', '2003-01-08', 'Masculino', '19989192662',
   'vinicius.correia0801@gmail.com', '123',
   '51912114801', 'Rua Teste, 123', 'Centro', 'São Paulo', 'SP', 'Profissional');

-- pega o id do usuário recém criado
SET @idProfTeste = (
  SELECT id_usuario FROM USUARIOS WHERE email='vinicius.correia0801@gmai.com' LIMIT 1
);

-- insere na tabela de profissionais
INSERT INTO PROFISSIONAIS (id_profissional, endereco_comercial, telefone_comercial)
VALUES (@idProfTeste, 'Sala Teste - Centro/SP', '11970009999');

-- adiciona uma habilidade de exemplo
INSERT INTO HABILIDADES (descricao, id_profissional, titulo, status)
VALUES ('Atendimentos de teste automatizado', @idProfTeste, 'Teste', 'Ativo');

-- 1) cria o usuário base
INSERT INTO usuarios
  (nome_completo, data_nascimento, genero, celular, email, senha, cpf_cnpj,
   endereco_rua, bairro, cidade, estado, tipo_usuario, status_usuario)
VALUES
  ('Cliente Teste Recuperacao', '1990-01-01', 'Prefiro não dizer', '11999999999',
   'digehix192@dawhe.com', '123', '12312345677',
   'Rua Teste, 123', 'Bairro Teste', 'Cidade Teste', 'SP',
   'Cliente', 'ATIVO');

-- 2) pega o id gerado
SET @novo_id_usuario = LAST_INSERT_ID();

-- 3) cria o cliente vinculado
INSERT INTO clientes (id_cliente) VALUES (@novo_id_usuario);

