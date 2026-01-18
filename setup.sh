#!/bin/bash

# Script para criar estrutura de pastas CasaOS para Prometheus + Grafana
# Execute: bash setup.sh

echo "🔧 Criando estrutura de pastas CasaOS..."

# Criar pastas prometheus
sudo mkdir -p /DATA/AppData/prometheus/config
sudo mkdir -p /DATA/AppData/prometheus/data

# Criar pastas grafana
sudo mkdir -p /DATA/AppData/grafana/data
sudo mkdir -p /DATA/AppData/grafana/provisioning/datasources
sudo mkdir -p /DATA/AppData/grafana/provisioning/dashboards

# Definir permissões
sudo chown -R 65534:65534 /DATA/AppData/prometheus/
sudo chown -R 472:472 /DATA/AppData/grafana/

echo "✅ Estrutura de pastas criada com sucesso!"
echo ""
echo "📁 Pastas criadas:"
echo "   /DATA/AppData/prometheus/config/"
echo "   /DATA/AppData/prometheus/data/"
echo "   /DATA/AppData/grafana/data/"
echo "   /DATA/AppData/grafana/provisioning/datasources/"
echo "   /DATA/AppData/grafana/provisioning/dashboards/"
echo ""
echo "🚀 Próximo passo: Coloque os arquivos .yml nas pastas e execute docker-compose up -d"
