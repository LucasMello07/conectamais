package conecta.service;

import com.sendgrid.Method;
import com.sendgrid.Request;
import com.sendgrid.Response;
import com.sendgrid.SendGrid;

import com.sendgrid.helpers.mail.Mail;
import com.sendgrid.helpers.mail.objects.Content;
import com.sendgrid.helpers.mail.objects.Email;

import java.io.IOException;

public class EmailServiceSendGrid {

    private final String apiKey;
    private final String fromEmail;

    public EmailServiceSendGrid() {
        // 1) Lê primeiro como System Property (-DCHAVE=valor), depois como Env Var
        this.apiKey   = firstNonBlank(
                System.getProperty("SENDGRID_API_KEY"),
                System.getenv("SENDGRID_API_KEY")
        );

        // opcional: remetente via property/env, senão cai no hardcoded
        this.fromEmail = firstNonBlank(
                System.getProperty("SENDGRID_FROM"),
                System.getenv("SENDGRID_FROM"),
                "correia.vinicius@aluno.ifsp.edu.br" // ajuste para o SEU remetente verificado
        );

        // Debug útil (mas sem vazar a chave completa)
        if (apiKey == null || apiKey.isBlank()) {
            System.err.println("[SendGrid] API key ausente. Defina SENDGRID_API_KEY (System Property -D ou Env Var).");
        } else {
            String masked = apiKey.length() > 8 ? apiKey.substring(0, 8) + "..." : "***";
            System.out.println("[SendGrid] API key OK (iniciando com): " + masked);
        }
        System.out.println("[SendGrid] Remetente FROM: " + fromEmail);
    }

    public boolean enviarEmail(String destinatario, String assunto, String conteudoHtml) {
        if (apiKey == null || apiKey.isBlank()) return false;

        // Remetente precisa estar VERIFICADO no painel do SendGrid (Single Sender ou Domain Auth)
        Email from = new Email(fromEmail);
        Email to   = new Email(destinatario);
        Content content = new Content("text/html", conteudoHtml);

        Mail mail = new Mail(from, assunto, to, content);

        SendGrid sg = new SendGrid(apiKey);
        Request request = new Request();

        try {
            request.setMethod(Method.POST);
            request.setEndpoint("mail/send");
            request.setBody(mail.build());

            Response response = sg.api(request);

            System.out.println("[SendGrid] Status: " + response.getStatusCode());
            System.out.println("[SendGrid] Body: " + response.getBody());
            return response.getStatusCode() == 202;

        } catch (IOException ex) {
            System.err.println("[SendGrid] Falha ao enviar: " + ex.getMessage());
            ex.printStackTrace();
            return false;
        }
    }

    private static String firstNonBlank(String... vals) {
        if (vals == null) return null;
        for (String v : vals) if (v != null && !v.isBlank()) return v;
        return null;
    }
}
