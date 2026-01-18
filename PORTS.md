# Configuração de Portas - 80/443

## 📍 Acesso via IP direto (portas padrão HTTP/HTTPS)

Com a nova configuração, você pode acessar os serviços apenas pelo IP, nas portas padrão:

```
http://10.41.10.140    (Prometheus)
http://10.41.10.141    (Grafana)
```

## ⚙️ Variáveis de Ambiente (.env)

O arquivo `.env` controla todas as configurações de porta:

```bash
# Prometheus
PROMETHEUS_IP=10.41.10.140
PROMETHEUS_PORT=80              # HTTP (acesso padrão)
PROMETHEUS_PORT_HTTPS=443       # HTTPS

# Grafana
GRAFANA_IP=10.41.10.141
GRAFANA_PORT=80                 # HTTP (acesso padrão)
GRAFANA_PORT_HTTPS=443          # HTTPS
```

## 🔧 Personalizando Portas

Se quiser usar portas diferentes, edite o `.env`:

```bash
# Exemplo: Prometheus na porta 9090, Grafana na porta 3000
PROMETHEUS_PORT=9090
GRAFANA_PORT=3000
```

Depois reinicie:
```bash
docker-compose down
docker-compose up -d
```

## 🔐 HTTPS/SSL

Para usar HTTPS (porta 443), você precisa:

### Opção 1: Nginx Reverse Proxy
Adicionar um container Nginx com certificado SSL que redireciona para Prometheus/Grafana

### Opção 2: Certificado auto-assinado
Gerar certificado e configurar nos containers

### Opção 3: Let's Encrypt
Usar Certbot para obter certificado válido

**Para agora:** Use HTTP (porta 80) e depois configure SSL conforme necessário.

## 📌 Como Funciona

O docker-compose lê as variáveis do `.env`:

```yaml
ports:
  - "${PROMETHEUS_PORT}:9090"      # Porta do host : Porta do container
  - "${PROMETHEUS_PORT_HTTPS}:9090"
```

Isso significa:
- **Porta 80 do host** → Porta 9090 do Prometheus
- **Porta 443 do host** → Porta 9090 do Prometheus

## ✅ Verificar

```bash
# Ver porta em uso
netstat -tuln | grep 80
netstat -tuln | grep 443

# Ou via Docker
docker ps | grep -E "prometheus|grafana"
```

## 📝 Acessar

Simplemente:
```
http://10.41.10.140     (Prometheus)
http://10.41.10.141     (Grafana - admin/admin123)
```

Sem precisar especificar porta! 🎯
