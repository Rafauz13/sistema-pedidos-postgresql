-- -------------------------------------------------------
-- PAS Banco de Dados - Script Completo
-- -------------------------------------------------------

DROP TABLE IF EXISTS itens_pedido CASCADE;
DROP TABLE IF EXISTS pedidos CASCADE;
DROP TABLE IF EXISTS produtos CASCADE;
DROP TABLE IF EXISTS clientes CASCADE;

CREATE TABLE clientes (
  id SERIAL PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  status VARCHAR(20) NOT NULL DEFAULT 'Ok'
);

CREATE TABLE produtos (
  id SERIAL PRIMARY KEY,
  nome VARCHAR(150) NOT NULL,
  preco NUMERIC(10,2) NOT NULL
);

CREATE TABLE pedidos (
  id SERIAL PRIMARY KEY,
  codigo_pedido VARCHAR(20) UNIQUE NOT NULL,
  cliente_id INTEGER NOT NULL REFERENCES clientes(id),
  data_pedido DATE NOT NULL,
  situacao VARCHAR(20) NOT NULL
);

CREATE TABLE itens_pedido (
  id SERIAL PRIMARY KEY,
  pedido_id INTEGER NOT NULL REFERENCES pedidos(id) ON DELETE CASCADE,
  produto_id INTEGER NOT NULL REFERENCES produtos(id),
  quantidade INTEGER NOT NULL CHECK (quantidade > 0),
  preco_unitario NUMERIC(10,2) NOT NULL
);

INSERT INTO clientes (nome, status) VALUES
('Ricardo', 'Ok'),
('Mariana', 'Ok'),
('Joao', 'Pendente'),
('Ana', 'Ok');

INSERT INTO produtos (nome, preco) VALUES
('Teclado', 120.00),
('Mouse', 60.00),
('Monitor 24"', 700.00),
('Cabo HDMI', 30.00),
('SSD 500GB', 400.00);

INSERT INTO pedidos (codigo_pedido, cliente_id, data_pedido, situacao) VALUES
('001', 1, '2025-02-10', 'Pago'),
('002', 1, '2025-03-05', 'Pago'),
('003', 1, '2025-05-20', 'Pago'),
('004', 1, '2025-09-11', 'Pago'),
('005', 1, '2025-10-15', 'Pendente'),
('006', 2, '2025-10-05', 'Pendente'),
('007', 4, '2025-11-12', 'Pendente'),
('008', 3, '2025-07-01', 'Pendente');

INSERT INTO itens_pedido (pedido_id, produto_id, quantidade, preco_unitario) VALUES
(5, 1, 1, 120.00),
(5, 2, 2, 60.00);

CREATE OR REPLACE FUNCTION impedir_venda_cliente_pendente()
RETURNS TRIGGER AS $$
BEGIN
    IF (SELECT status FROM clientes WHERE id = NEW.cliente_id) = 'Pendente' THEN
        RAISE EXCEPTION 'Não é possível vender para cliente com status Pendente.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_cliente_pendente
BEFORE INSERT ON pedidos
FOR EACH ROW
EXECUTE FUNCTION impedir_venda_cliente_pendente();
