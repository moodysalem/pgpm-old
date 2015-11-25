package com.moodysalem.pgpmessager;

import com.moodysalem.jaxrs.lib.BaseApplication;
import com.moodysalem.jaxrs.lib.factories.JAXRSEntityManagerFactory;
import com.moodysalem.jaxrs.lib.factories.MailSessionFactory;
import org.glassfish.hk2.utilities.binding.AbstractBinder;
import org.glassfish.jersey.process.internal.RequestScoped;

import javax.mail.Session;
import javax.persistence.EntityManager;
import javax.ws.rs.ApplicationPath;

@ApplicationPath("")
public class Application extends BaseApplication {
    public Application() {
        super();

        packages("com.moodysalem.pgpmessager.resources");

        register(new AbstractBinder() {
            @Override
            protected void configure() {
                String context = System.getProperty("LIQUIBASE_CONTEXT", "");

                bindFactory(new JAXRSEntityManagerFactory(
                    System.getProperty("JDBC_CONNECTION_STRING"),
                    System.getProperty("JDBC_CONNECTION_USERNAME"),
                    System.getProperty("JDBC_CONNECTION_PASSWORD"),
                    "pgpmessager",
                    "db/master-changelog.xml",
                    System.getProperty("DEBUG") != null,
                    context
                )).to(EntityManager.class).in(RequestScoped.class).proxy(true);

                int port = 25;
                if (System.getProperty("SMTP_PORT") != null) {
                    try {
                        port = Integer.parseInt(System.getProperty("SMTP_PORT"));
                    } catch (NumberFormatException ignored) {
                    }
                }

                bindFactory(
                    new MailSessionFactory(
                        System.getProperty("SMTP_HOST"),
                        System.getProperty("SMTP_USERNAME"),
                        System.getProperty("SMTP_PASSWORD"),
                        port
                    )
                ).to(Session.class).in(RequestScoped.class);
            }
        });
    }

    @Override
    public boolean forceHttps() {
        return true;
    }

    @Override
    public boolean allowCORS() {
        return false;
    }
}
