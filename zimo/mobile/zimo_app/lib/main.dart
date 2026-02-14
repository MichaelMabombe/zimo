import 'package:flutter/material.dart';

void main() {
  runApp(const ZimoApp());
}

class ZimoApp extends StatelessWidget {
  const ZimoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zimo',
      theme: ThemeData(
        primaryColor: Colors.blueGrey,
        useMaterial3: true,
      ),
      home: const SplashPage(),
    );
  }
}

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          children: const [
            _HeroHeader(),
            SizedBox(height: 10),
            Center(
              child: Text(
                'Powered by ZIMO',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                  letterSpacing: 0.4,
                ),
              ),
            ),
            SizedBox(height: 20),
            _IntroCard(),
            SizedBox(height: 24),
            _SectionTitle(title: 'Funcionalidades da ZIMO'),
            SizedBox(height: 12),
            _FeatureCard(
              icon: Icons.apartment_rounded,
              title: 'Gestao de Imoveis',
              bullets: [
                'Cadastro de imoveis, blocos, apartamentos e unidades',
                'Associacao de proprietarios, inquilinos e gestores',
                'Historico completo de cada imovel',
              ],
            ),
            SizedBox(height: 12),
            _FeatureCard(
              icon: Icons.build_rounded,
              title: 'Manutencao e Oficina',
              bullets: [
                'Abertura de pedidos de reparacao',
                'Classificacao por prioridade e tipo de avaria',
                'Ordens de servico com acompanhamento de status',
                'Historico tecnico e relatorios de manutencao',
              ],
            ),
            SizedBox(height: 12),
            _FeatureCard(
              icon: Icons.local_shipping_rounded,
              title: 'Logistica e Operacoes',
              bullets: [
                'Gestao de equipamentos, materiais e ativos',
                'Controle de movimentacoes e localizacoes',
                'Apoio as equipas tecnicas no terreno',
                'Integracao com pedidos de manutencao',
              ],
            ),
            SizedBox(height: 12),
            _FeatureCard(
              icon: Icons.people_alt_rounded,
              title: 'Gestao de Utilizadores',
              bullets: [
                'Perfis e niveis de acesso (admin, tecnico, logistica, gestor, cliente)',
                'Controle de permissoes por modulo',
                'Auditoria de acoes no sistema',
              ],
            ),
            SizedBox(height: 12),
            _FeatureCard(
              icon: Icons.insights_rounded,
              title: 'Relatorios e Indicadores',
              bullets: [
                'Relatorios operacionais e tecnicos',
                'Estatisticas de avarias, tempo de resposta e custos',
                'Apoio a tomada de decisao',
              ],
            ),
            SizedBox(height: 12),
            _FeatureCard(
              icon: Icons.lock_rounded,
              title: 'Seguranca e Controle',
              bullets: [
                'Autenticacao e sessoes seguras',
                'Registos de atividade (logs)',
                'Protecao de dados e acesso controlado',
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroHeader extends StatelessWidget {
  const _HeroHeader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            height: 54,
            width: 54,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.real_estate_agent_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ZIMO',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Plataforma PropTech',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color:
                        theme.colorScheme.onPrimaryContainer.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _IntroCard extends StatelessWidget {
  const _IntroCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        'A ZIMO e uma plataforma PropTech (tecnologia imobiliaria) criada para digitalizar, '
        'organizar e automatizar a gestao de imoveis, condominios e operacoes tecnicas. '
        'Ela centraliza pessoas, ativos, pedidos, logistica e manutencao num unico sistema, '
        'acessivel por web e mobile.',
        style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.bullets,
  });

  final IconData icon;
  final String title;
  final List<String> bullets;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: theme.colorScheme.primary),
              const SizedBox(width: 10),
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...bullets.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('•  '),
                  Expanded(
                    child: Text(
                      item,
                      style: theme.textTheme.bodyMedium?.copyWith(height: 1.3),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
