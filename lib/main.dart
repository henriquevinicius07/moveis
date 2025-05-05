import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(const MoveisPlanejadosApp());
}

class MoveisPlanejadosApp extends StatelessWidget {
  const MoveisPlanejadosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sloan Planejados',
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> _imagensFundo = [
    'assets/images/ft1.jpg',
    'assets/images/ft2.jpg',
    'assets/images/ft3.jpg',
    'assets/images/ft4.jpg',
    'assets/images/ft5.jpg',
    'assets/images/ft6.jpg',
  ];

  int _indexImagemAtual = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 6), (timer) {
      setState(() {
        _indexImagemAtual = (_indexImagemAtual + 1) % _imagensFundo.length;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _abrirLink(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Não foi possível abrir $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fundo animado com fade + zoom
          AnimatedSwitcher(
            duration: const Duration(seconds: 2),
            switchInCurve: Curves.easeInOut,
            switchOutCurve: Curves.easeInOut,
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: Tween<double>(
                    begin: 1.05,
                    end: 1.0,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: Image.asset(
              _imagensFundo[_indexImagemAtual],
              key: ValueKey<String>(_imagensFundo[_indexImagemAtual]),
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
            ),
          ),
          Container(color: Colors.black.withOpacity(0.3)),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(24),
                  constraints: const BoxConstraints(maxWidth: 400),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 15,
                        offset: Offset(0, 8),
                      ),
                    ],
                    border: Border.all(color: Colors.brown),
                  ),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 60,
                        backgroundImage: AssetImage(
                          'assets/images/logo_sloan.png',
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Sloan Planejados',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5D4037),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Inspirando sonhos, construindo realidades.',
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(FontAwesomeIcons.whatsapp),
                            color: Colors.green,
                            onPressed:
                                () => _abrirLink('https://wa.me/SEUNUMERO'),
                          ),
                          IconButton(
                            icon: const Icon(FontAwesomeIcons.instagram),
                            color: Colors.purple,
                            onPressed:
                                () => _abrirLink(
                                  'https://www.instagram.com/sloan_planejados?igsh=MWszdndhNm10cXZodg==',
                                ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.location_on),
                            color: const Color.fromARGB(255, 194, 24, 12),
                            onPressed:
                                () => _abrirLink(
                                  'https://www.google.com/maps/place/SUA_LOCALIZAÇÃO',
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      _buildButton(
                        text: 'Catálogo de Móveis',
                        icon: Icons.book,
                        corHover: const Color(0xFF5D4037),
                        onTap: () => _abrirLink('https://linkparacatalogo.com'),
                      ),
                      _buildButton(
                        text: 'Nosso Instagram',
                        icon: FontAwesomeIcons.instagram,
                        corHover: const Color(0xFFC13584),
                        onTap:
                            () => _abrirLink(
                              'https://www.instagram.com/sloan_planejados?igsh=MWszdndhNm10cXZodg==',
                            ),
                        isInstagram: true,
                      ),
                      _buildButton(
                        text: 'Nossa Localização',
                        icon: Icons.location_on,
                        corHover: Colors.red,
                        onTap:
                            () => _abrirLink(
                              'https://www.google.com/maps/place/SUA_LOCALIZAÇÃO',
                            ),
                      ),
                      _buildButton(
                        text: 'Fale pelo WhatsApp',
                        icon: FontAwesomeIcons.whatsapp,
                        corHover: const Color(0xFF25D366),
                        onTap: () => _abrirLink('tel:+5563992963232'),
                      ),
                      _buildButton(
                        text: 'Ligar Agora',
                        icon: Icons.call,
                        corHover: const Color.fromARGB(255, 6, 20, 209),
                        onTap: () => _abrirLink('tel:+5563992963232'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required IconData icon,
    required Color corHover,
    required VoidCallback onTap,
    bool isInstagram = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: _HoverButton(
        text: text,
        icon: icon,
        corHover: corHover,
        onTap: onTap,
        isInstagram: isInstagram,
      ),
    );
  }
}

class _HoverButton extends StatefulWidget {
  final String text;
  final IconData icon;
  final Color corHover;
  final VoidCallback onTap;
  final bool isInstagram;

  const _HoverButton({
    required this.text,
    required this.icon,
    required this.corHover,
    required this.onTap,
    this.isInstagram = false,
  });

  @override
  State<_HoverButton> createState() => _HoverButtonState();
}

class _HoverButtonState extends State<_HoverButton> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 1.0, end: _isHovering ? 1.02 : 1.0),
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          builder: (context, scale, child) {
            return Transform.scale(scale: scale, child: child);
          },
          child: Container(
            decoration: BoxDecoration(
              gradient:
                  _isHovering && widget.isInstagram
                      ? const LinearGradient(
                        colors: [
                          Color(0xFFF58529),
                          Color(0xFFDD2A7B),
                          Color(0xFF8134AF),
                        ],
                      )
                      : null,
              color:
                  !_isHovering || !widget.isInstagram
                      ? (_isHovering ? widget.corHover : Colors.white)
                      : null,
              borderRadius: BorderRadius.circular(30),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(
              children: [
                Icon(
                  widget.icon,
                  color: _isHovering ? Colors.white : Colors.brown,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.text,
                    style: TextStyle(
                      color: _isHovering ? Colors.white : Colors.brown,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: _isHovering ? Colors.white : Colors.brown.shade300,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
