# 📊 Monitoring Stack para CasaOS

Criado por I.A e desenvolvido por LUAN

Prometheus + Grafana com suporte a macvlan para CasaOS


## 🎯 Características

✅ **Prometheus** - Coleta e armazenamento de métricas  
✅ **Grafana** - Visualização de dados com dashboards  
✅ **Macvlan** - IPs estáticos na rede local (10.41.10.140 e 10.41.10.141)  
✅ **Volumes Persistentes** - Dados em `/DATA/AppData/`  
✅ **Healthchecks** - Verificação automática de saúde dos containers  
✅ **Alertas** - Regras de alertas configuráveis  
✅ **Pronto para Portainer** - Integração com Git Repository  

---

## 📋 Pré-requisitos

- CasaOS instalado e rodando
- Portainer instalado (opcional, mas recomendado)
- Docker e Docker Compose funcionando
- Rede macvlan `macvlan-dhcp` criada com:
  - Subnet: `10.41.10.0/24`
  - Gateway: `10.41.10.1`
  - IP Range: `10.41.10.128/25`

---

## 🚀 Instalação Rápida

### **Opção 1: Via Terminal (SSH)**

#### 1️⃣ Clonar o repositório
```bash
cd /home/casaos
git clone https://github.com/luanscps/monitoring.git
cd monitoring
```

#### 2️⃣ Executar script de setup
```bash
bash setup.sh
```
Isso criará automaticamente:
- `/DATA/AppData/prometheus/config/`
- `/DATA/AppData/prometheus/data/`
- `/DATA/AppData/grafana/data/`
- `/DATA/AppData/grafana/provisioning/datasources/`
- `/DATA/AppData/grafana/provisioning/dashboards/`

#### 3️⃣ Copiar arquivos de configuração
```bash
# Copiar configs do Prometheus
cp config/prometheus/prometheus.yml /DATA/AppData/prometheus/config/
cp config/prometheus/alert.yml /DATA/AppData/prometheus/config/

# Copiar configs do Grafana
cp config/grafana/datasources/prometheus.yml /DATA/AppData/grafana/provisioning/datasources/
cp config/grafana/dashboards/dashboard.yml /DATA/AppData/grafana/provisioning/dashboards/
```

#### 4️⃣ Iniciar os containers
```bash
docker-compose up -d
```

#### 5️⃣ Verificar status
```bash
docker-compose ps
```

Deve aparecer:
```
NAME        STATUS
prometheus  Up (healthy)
grafana     Up (healthy)
```

---

### **Opção 2: Via Portainer (Git Repository)**

#### 1️⃣ Acessar Portainer
- URL: `http://seu-ip:9001`
- Faça login

#### 2️⃣ Navegar para Stacks
- Menu esquerdo → **Stacks**
- Clique em **"+ Add stack"** ou **"+ Adicionar stack"**

#### 3️⃣ Preencher formulário
```
Name: monitoring
Environment: Local
Build method: Git repository
```

#### 4️⃣ Configurar Git Repository
```
Repository URL: https://github.com/luanscps/monitoring
Repository reference: main
Compose path: docker-compose.yml
```

#### 5️⃣ Deploy
- Clique em **"Deploy the stack"**
- Aguarde (~1 minuto)

#### 6️⃣ Verificar
- Stacks → monitoring → Containers
- Deve mostrar `prometheus` e `grafana` como **running**

---

## 📍 Acessar os Serviços

Após a instalação:

| Serviço | URL | IP | Credenciais |
|---------|-----|-----|-------------|
| **Prometheus** | [http://10.41.10.140:9090](http://10.41.10.140:9090) | 10.41.10.140 | Sem auth |
| **Grafana** | [http://10.41.10.141:3000](http://10.41.10.141:3000) | 10.41.10.141 | admin / admin123 |

---

## 🔐 Alterar Senha do Grafana

### Pelo terminal:
```bash
docker exec -it grafana grafana-cli admin reset-admin-password SUA_NOVA_SENHA
```

### Pela interface:
1. Acesse Grafana → Clique no avatar (canto superior direito)
2. Selecione "Change password"
3. Digite a nova senha

---

## 📊 Importar Dashboards

### Dashboard Node Exporter (ID: 1860)
1. Acesse Grafana → **+ (Create)** → **Import**
2. Cole o ID: `1860`
3. Selecione a datasource: **Prometheus**
4. Clique em **Import**

---

## 📁 Estrutura do Projeto

```
monitoring/
├── docker-compose.yml                      # Config dos containers
├── setup.sh                                # Script de setup
├── README.md                               # Este arquivo
├── .gitignore
└── config/
    ├── prometheus/
    │   ├── prometheus.yml                  # Config Prometheus
    │   └── alert.yml                       # Regras de alertas
    └── grafana/
        ├── datasources/
        │   └── prometheus.yml              # Conexão Prometheus
        └── dashboards/
            └── dashboard.yml               # Provisioning
```

---

## ⚙️ Configurações Importantes

### Alterar IP do Prometheus
Em `docker-compose.yml`, linha 21:
```yaml
networks:
  macvlan-dhcp:
    ipv4_address: 10.41.10.140  # Altere aqui
```

### Alterar IP do Grafana
Em `docker-compose.yml`, linha 49:
```yaml
networks:
  macvlan-dhcp:
    ipv4_address: 10.41.10.141  # Altere aqui
```

### Alterar Retenção de Dados
Em `docker-compose.yml`, linha 13:
```yaml
- '--storage.tsdb.retention.time=30d'  # Altere para: 7d, 15d, 60d, etc
```

### Alterar Senha Padrão do Grafana
Em `docker-compose.yml`, linha 36:
```yaml
- GF_SECURITY_ADMIN_PASSWORD=admin123  # Altere aqui
```

---

## 🔧 Troubleshooting

### ❌ Container não inicia
```bash
# Ver logs
docker logs prometheus
docker logs grafana

# Verificar estrutura de pastas
ls -la /DATA/AppData/prometheus/
ls -la /DATA/AppData/grafana/

# Verificar permissões
sudo chown -R 65534:65534 /DATA/AppData/prometheus/
sudo chown -R 472:472 /DATA/AppData/grafana/
```

### ❌ Grafana não conecta ao Prometheus
1. Acesse Grafana → Configuration → Data Sources
2. Clique em "Prometheus"
3. Altere URL para: `http://prometheus:9090`
4. Clique em "Save & Test"

### ❌ Rede macvlan não encontrada
```bash
# Verificar rede
docker network ls

# Se não existir, criar:
docker network create -d macvlan \
  --subnet=10.41.10.0/24 \
  --gateway=10.41.10.1 \
  --ip-range=10.41.10.128/25 \
  -o parent=eth0 \
  macvlan-dhcp
```

### ❌ Prometheus mostra "0 series"
1. Acesse Prometheus → Status → Targets
2. Verifique se há erros de conexão
3. Adicione exporters conforme necessário

---

## 📊 Adicionar Node Exporter

Para monitorar o servidor CasaOS:

#### 1️⃣ Adicionar ao docker-compose.yml:
```yaml
  node-exporter:
    image: prom/node-exporter:latest
    container_name: node-exporter
    restart: unless-stopped
    ports:
      - "9100:9100"
    command:
      - '--path.procfs=/host/proc'
      - '--path.rootfs=/'
      - '--path.sysfs=/host/sys'
    volumes:
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /:/rootfs:ro
    networks:
      - macvlan-dhcp
```

#### 2️⃣ Adicionar ao prometheus.yml:
```yaml
  - job_name: 'node-exporter'
    static_configs:
      - targets: ['node-exporter:9100']
```

#### 3️⃣ Reiniciar:
```bash
docker-compose down
docker-compose up -d
```

---

## 📚 Recursos Úteis

- [Prometheus Docs](https://prometheus.io/docs)
- [Grafana Docs](https://grafana.com/docs)
- [Grafana Dashboards](https://grafana.com/grafana/dashboards)
- [PromQL Queries](https://prometheus.io/docs/prometheus/latest/querying/basics/)
- [CasaOS Wiki](https://wiki.casaos.io)

---

## 🔄 Atualizar Configurações via Git

Se fizer alterações no repositório:

### Via Terminal:
```bash
cd ~/monitoring
git pull origin main
docker-compose up -d
```

### Via Portainer:
1. Stacks → monitoring
2. Clique em **"Pull & Redeploy"**
3. Aguarde a conclusão

---

## 💾 Backup e Restore

### Fazer Backup:
```bash
# Backup das configurações
tar -czf monitoring-backup.tar.gz /DATA/AppData/prometheus /DATA/AppData/grafana

# Copiar para local seguro
cp monitoring-backup.tar.gz /mnt/storage/backups/
```

### Restaurar Backup:
```bash
# Extrair
tar -xzf monitoring-backup.tar.gz -C /

# Reiniciar containers
docker-compose restart
```

---

## 📝 Licença

Este projeto é de código aberto e livre para uso.

---

## 🤝 Suporte

Para dúvidas ou problemas:
1. Verifique os logs: `docker logs prometheus` / `docker logs grafana`
2. Consulte a seção Troubleshooting
3. Abra uma issue no GitHub

---

**Última atualização:** Janeiro 2026  
**Versão:** 1.0.0
