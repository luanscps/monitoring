# 📊 Monitoring Stack - Prometheus + Grafana + Node Exporter + AdGuard Exporter

**Criado por I.A e desenvolvido por LUAN 👨‍💻**

## Prometheus + Grafana com suporte a macvlan para CasaOS

Projeto Idealizado para o meu HOMELAB:

**IBM LENOVO X3650 M5 5462AC1**
- 24 x Intel(R) Xeon(R) CPU E5-2670 v3 1x Socket
- 64GB RAM DDR4 2133 MHz 4x16GB Samsung SF4722G4CKHH6DFSDS
- RAID: ServeRAID M1215 em RAID10 de 5 drives com 638.00gb
- Virtualizado em PROXMOX v8.4
- INTRANET: MIKROTIK X64 BRIDGE + VLAN

🎉🎉🎉🎉

---

## 🚀 Serviços Inclusos

| Serviço | IP | Porta | Função |
|---------|----|----|----------|
| **Prometheus** | 10.41.10.140 | 9090 | Coleta e armazena métricas |
| **Grafana** | 10.41.10.141 | 3000 | Visualiza dados em dashboards |
| **Node Exporter** | 10.41.10.144 | 9100 | Monitora saúde do servidor |
| **AdGuard Exporter** | 10.41.10.145 | 9618 | Monitora AdGuard Home |

---

## 📋 Pré-requisitos

- Docker e Docker Compose instalados
- Rede macvlan criada:
  ```bash
  docker network create -d macvlan \
    --subnet=10.41.10.0/24 \
    --gateway=10.41.10.1 \
    -o parent=eth0 \
    macvlan-dhcp
  ```
- Diretórios para dados:
  ```bash
  sudo mkdir -p /DATA/AppData/prometheus/{config,data}
  sudo mkdir -p /DATA/AppData/grafana/data
  sudo mkdir -p /DATA/AppData/grafana/provisioning/{datasources,dashboards}
  ```

---

## 🔧 Instalação

### 1. Clone o repositório
```bash
cd ~/
git clone https://github.com/luanscps/monitoring.git
cd monitoring
```

### 2. Configure as credenciais (obrigatório)

Edite o `docker-compose.yml` e procure pela seção `adguard-exporter`:

```yaml
adguard-exporter:
  environment:
    - ADGUARD_SERVERS=http://10.41.10.130:80
    - ADGUARD_USERNAMES=luan              # ← Seu username do AdGuard
    - ADGUARD_PASSWORDS=sua_senha_aqui    # ← Sua senha em texto plano
    - INTERVAL=30s
```

**Importante:** Use a **senha em texto plano**, não a criptografada!

### 3. Ajuste permissões

```bash
sudo chown -R 472:472 /DATA/AppData/grafana/
sudo chmod -R 755 /DATA/AppData/grafana/
```

### 4. Inicie os containers

```bash
docker-compose up -d
```

### 5. Verifique se está tudo rodando

```bash
docker-compose ps
docker logs prometheus
docker logs grafana
docker logs node-exporter
docker logs adguard-exporter
```

---

## 🌐 Acesso aos Serviços

### Prometheus
```
http://10.41.10.140:9090
```
- Targets: Menu → Targets (status dos scrapers)
- Graph: Explore métricas

### Grafana
```
http://10.41.10.141:3000
```
- **Login padrão:** admin / admin123
- **Mudar senha:** Settings → User → Change Password

### Node Exporter (métricas do servidor)
```
http://10.41.10.144:9100/metrics
```

### AdGuard Exporter (métricas do AdGuard)
```
http://10.41.10.145:9618/metrics
```

---

## 📊 Configurar Datasources no Grafana

1. Abra Grafana: `http://10.41.10.141:3000`
2. Vá em **Connections** → **Data sources** → **Add data source**
3. Escolha **Prometheus**
4. Configure:
   - **Name:** Prometheus
   - **URL:** http://10.41.10.140:9090
   - Clique **Save & test**

---

## 📈 Importar Dashboards

### Dashboard Node Exporter (Servidor)
1. Grafana → **Dashboards** → **Create** → **Import**
2. Cole o ID: `1860`
3. Selecione datasource: **Prometheus**
4. Clique **Import**

### Dashboard AdGuard
1. Grafana → **Dashboards** → **Create** → **Import**
2. Cole o ID: `13414`
3. Selecione datasource: **Prometheus**
4. Clique **Import**

---

## 🐛 Troubleshooting

### AdGuard Exporter com erro "panic: no usernames supplied"
- Verifique se `ADGUARD_USERNAMES` e `ADGUARD_PASSWORDS` não estão vazios
- Use **texto plano** para password, não a versão criptografada

### Grafana com erro de permissão
```bash
sudo chown -R 472:472 /DATA/AppData/grafana/
sudo chmod -R 755 /DATA/AppData/grafana/
docker-compose restart grafana
```

### Prometheus não conecta em serviços
- Verifique se os IPs (10.41.10.140-145) estão corretos
- Teste conectividade: `docker exec prometheus wget -O- http://10.41.10.144:9100/metrics`

---

## ⚙️ Variáveis de Ambiente

### Prometheus
```yaml
- Retention: 30 dias
- Scrape interval: 15s
- Evaluation interval: 15s
```

### Grafana
```yaml
- Admin User: admin
- Admin Password: admin123 (MUDE isso!)
- Plugins: grafana-clock-panel, grafana-piechart-panel
```

### Node Exporter
```yaml
- Coleta métricas do servidor
- Portas expõe: /proc, /sys, /
```

### AdGuard Exporter
```yaml
- ADGUARD_SERVERS: URL do AdGuard
- ADGUARD_USERNAMES: Username do AdGuard
- ADGUARD_PASSWORDS: Senha do AdGuard (texto plano)
- INTERVAL: Intervalo de scraping (padrão 30s)
```

---

## 🛠️ Gerenciamento

### Parar os containers
```bash
docker-compose down
```

### Reiniciar
```bash
docker-compose restart
```

### Ver logs
```bash
docker-compose logs -f prometheus
docker-compose logs -f grafana
docker-compose logs -f node-exporter
docker-compose logs -f adguard-exporter
```

### Atualizar imagens
```bash
docker-compose pull
docker-compose up -d
```

---

## 🔐 Segurança

1. **Mude a senha do Grafana** imediatamente após primeira login
2. **Altere credenciais padrão** do AdGuard se aplicável
3. **Use HTTPS** em produção (configure reverse proxy com SSL)
4. **Restrinja acesso** aos IPs por firewall

---

## 📚 Referências

- [Prometheus Documentation](https://prometheus.io/docs/)
- [Grafana Documentation](https://grafana.com/docs/)
- [Node Exporter GitHub](https://github.com/prometheus/node_exporter)
- [AdGuard Exporter GitHub](https://github.com/henrywhitaker3/adguard-exporter)

---

## 📧 Suporte

Este repositório foi criado para CasaOS com configuração de macvlan e IPs estáticos.

Para dúvidas ou problemas, abra uma issue no GitHub! 🙏
