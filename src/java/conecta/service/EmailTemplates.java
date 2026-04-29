package conecta.service;

public class EmailTemplates {

    /**
     * Template de e-mail para redefinição de senha.
     * @param nome  Nome do usuário (pode ser null)
     * @param link  Link absoluto para a página de nova senha (com token)
     * @return HTML completo
     */
    public static String resetPassword(String nome, String link) {
        String saudacao = (nome != null && !nome.isBlank())
                ? "Olá, " + escapeHtml(nome) + "!"
                : "Olá!";

        String preheader = "Use o link para redefinir sua senha. O link expira em breve.";
        String assunto = "Conecta+ • Redefinir senha";

        String body = """
            <p style="margin:0 0 16px;">%SAUDACAO%</p>
            <p style="margin:0 0 16px;">
                Recebemos uma solicitação para redefinir a sua senha no <strong>Conecta+</strong>.
            </p>
            <p style="margin:0 0 16px;">
                Clique no botão abaixo para criar uma nova senha. Se você não solicitou esta ação, pode ignorar este e-mail.
            </p>
            <p style="margin:24px 0;">
                <a href="%LINK%" target="_blank"
                   style="display:inline-block;padding:12px 20px;text-decoration:none;border-radius:8px;
                          background:#e11d48;color:#fff;font-weight:600;">
                    Redefinir minha senha
                </a>
            </p>
            <p style="margin:0 0 16px;font-size:14px;color:#4b5563;">
                Se o botão não funcionar, copie e cole este link no seu navegador:<br>
                <span style="word-break:break-all;">%LINK%</span>
            </p>
            <hr style="border:none;border-top:1px solid #e5e7eb;margin:24px 0;">
            <p style="margin:0;color:#6b7280;font-size:12px;">
                Por segurança, este link expira após um período. Caso expire, solicite novamente a recuperação de senha.
            </p>
        """.replace("%SAUDACAO%", saudacao)
           .replace("%LINK%", link);

        return basicWrapper(assunto, preheader, body);
    }

    /** Um wrapper básico e responsivo para e-mails HTML. */
    public static String basicWrapper(String title, String preheader, String innerHtml) {
        String safeTitle = (title == null ? "Conecta+" : escapeHtml(title));
        String safePreheader = (preheader == null ? "" : preheader);

        return """
        <!DOCTYPE html>
        <html lang="pt-BR">
        <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width,initial-scale=1.0">
          <title>%TITLE%</title>
          <style>
            @media (prefers-color-scheme: dark) {
              body { background: #0b1020 !important; color: #e5e7eb !important; }
              .card { background: #111827 !important; }
            }
          </style>
        </head>
        <body style="margin:0;padding:0;background:#f3f4f6;font-family:-apple-system,BlinkMacSystemFont,Segoe UI,Roboto,Helvetica,Arial,sans-serif;color:#111827;">
          <!-- Preheader (escondido nos clients, mas útil) -->
          <div style="display:none;max-height:0;overflow:hidden;opacity:0;color:transparent;">
            %PREHEADER%
          </div>

          <table role="presentation" cellpadding="0" cellspacing="0" width="100%%">
            <tr>
              <td align="center" style="padding:32px 16px;">
                <table role="presentation" cellpadding="0" cellspacing="0" width="100%%" style="max-width:600px;">
                  <tr>
                    <td class="card" style="background:#ffffff;border-radius:12px;padding:24px;box-shadow:0 2px 6px rgba(0,0,0,0.06);">
                      <h1 style="margin:0 0 12px;font-size:20px;line-height:1.4;">%TITLE%</h1>
                      <div style="font-size:16px;line-height:1.6;">
                        %CONTENT%
                      </div>
                    </td>
                  </tr>
                  <tr>
                    <td align="center" style="padding:16px;color:#9ca3af;font-size:12px;">
                      © Conecta+ — Não responda este e-mail. Suporte: suporte@conecta.plus
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
          </table>
        </body>
        </html>
        """.replace("%TITLE%", safeTitle)
           .replace("%PREHEADER%", escapeHtml(safePreheader))
           .replace("%CONTENT%", innerHtml);
    }

    /** Escape bem simples só pra evitar quebrar HTML ao inserir textos de usuário. */
    private static String escapeHtml(String s) {
        return s == null ? "" : s
                .replace("&","&amp;")
                .replace("<","&lt;")
                .replace(">","&gt;")
                .replace("\"","&quot;")
                .replace("'","&#39;");
    }
}
