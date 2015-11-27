import com.moodysalem.jaxrs.lib.test.BaseTest;
import io.pgpm.Application;
import org.glassfish.jersey.server.ResourceConfig;

public class PGPMTest extends BaseTest {
    @Override
    public ResourceConfig getResourceConfig() {
        System.setProperty("JDBC_CONNECTION_STRING", "jdbc:h2:mem:test;DB_CLOSE_DELAY=-1");
        System.setProperty("JDBC_CONNECTION_USERNAME", "sa");
        System.setProperty("JDBC_CONNECTION_PASSWORD", "sa");
        System.setProperty("LIQUIBASE_CONTEXT", "test");

        System.setProperty("SMTP_HOST", "localhost");
        System.setProperty("SMTP_USERNAME", "fake");
        System.setProperty("SMTP_PASSWORD", "fake");

        return new Application();
    }
}
