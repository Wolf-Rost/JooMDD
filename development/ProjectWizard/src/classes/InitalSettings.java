

package classes;

import com.intellij.openapi.components.ProjectComponent;
import com.intellij.openapi.fileEditor.FileEditorManager;
import com.intellij.openapi.project.Project;
import com.intellij.openapi.vfs.LocalFileSystem;
import com.intellij.openapi.vfs.VirtualFile;
import com.intellij.util.PathUtil;
import org.jetbrains.annotations.NotNull;

import java.io.*;
import java.nio.channels.FileLock;

/**
 * Created by Leon on 21.01.16.
 */
public class InitalSettings implements ProjectComponent {

    private Project project;

    public InitalSettings(Project project) {
        this.project = project;
    }

    @Override
    public void projectOpened() {

    }


    @Override
    public void projectClosed() {

    }

    @Override
    public void initComponent() {
        if (eJSLWizardStep.getwizardactive()) {
            eJSLWizardStep.setwizardstatus(false);
            try {
                File projectfile = new File(project.getBasePath() + "/" + project.getName() + ".iml");
                StringBuilder projectconfig = new StringBuilder();
                FileReader fr = new FileReader(PathUtil.getJarPathForClass(getClass()) + "/resources/settings/projectfile.xml");
                BufferedReader br = new BufferedReader(fr);
                String buffer = "";
                while ((buffer = br.readLine()) != null) {
                    projectconfig.append((buffer + "\n"));
                }


                projectfile.createNewFile();
                FileWriter fw = new FileWriter(project.getBasePath() + "/" + project.getName() + ".iml");
                BufferedWriter bw = new BufferedWriter(fw);

                bw.write(projectconfig.toString());

                br.close();
                bw.close();
                fw.close();
                fr.close();

                FileLock lock = new RandomAccessFile(project.getBasePath() + "/" + project.getName() + ".iml", "r").getChannel().tryLock(0L, Long.MAX_VALUE,true);
                lock.release();

            } catch (Exception e) {
                e.printStackTrace();
            }

            File src = new File(project.getBasePath() + "/src");
            File src_gen = new File(project.getBasePath() + "/src-gen");
            File model = new File(project.getBasePath() + "/src/Model.eJSL");

            StringBuilder example = new StringBuilder();

            try {
                src.mkdir();
                src_gen.mkdir();
                FileWriter fw = new FileWriter(project.getBasePath() + "/src/Model.eJSL");
                FileReader fr = new FileReader(PathUtil.getJarPathForClass(getClass()) + "/templates/" + eJSLWizardStep.getOption());
                BufferedReader br = new BufferedReader(fr);
                String buffer = "";
                while ((buffer = br.readLine()) != null) {
                    example.append((buffer + "\n"));
                }

                model.createNewFile();
                BufferedWriter bw = new BufferedWriter(fw);
                bw.write(example.toString());

                br.close();
                bw.close();
                fr.close();
                fw.close();


            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    @Override
    public void disposeComponent() {

    }

    @NotNull
    @Override
    public String getComponentName() {
        return "classes.InitalSettings";
    }
}

