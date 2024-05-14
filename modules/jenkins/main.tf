resource "helm_release" "jenkins" {
  name       = "jenkins"
  repository = "https://charts.jenkins.io"
  chart      = "jenkins"
  namespace  = "jenkins"

  set {
    name  = "master.jenkinsUrl"
    value = "http://${var.master_private_ip}:8080"
  }

  set {
    name  = "master.adminPassword"
    value = var.jenkins_admin_password
  }

  set {
    name  = "master.installPlugins"
    value = "configuration-as-code:1.51,job-dsl:1.77"
  }

  set {
    name  = "master.CasC.configScripts"
    value = "jenkins-casc=/var/jenkins_home/casc_configs/jenkins.yaml"
  }

  set {
    name  = "master.yamlConfig"
    value = <<-EOT
    persistence:
      enabled: true
      storageClass: standard
      size: 8Gi
      annotations: {}
      accessMode: ReadWriteOnce
    EOT
  }

  values = [<<-EOT
    Master:
      JavaOpts: -Djenkins.install.runSetupWizard=false
      casc:
        configScripts:
          default: |
            jenkins:
              systemMessage: "Jenkins configured automatically by Jenkins Configuration as Code plugin\n\n"
              numExecutors: 2
              securityRealm:
                local:
                  allowsSignup: false
                  users:
                    - id: "admin"
                      password: "${var.jenkins_admin_password}"
              authorizationStrategy:
                loggedInUsersCanDoAnything:
                  allowAnonymousRead: false
              credentials:
                system:
                  domainCredentials:
                    - credentials:
                        - usernamePassword:
                            scope: GLOBAL
                            id: "github-credentials"
                            description: "GitHub Credentials"
                            username: "${local.github_user}"
                            password: "${local.github_pat}"
              jobs:
                - script: >
                    pipelineJob('example') {
                      definition {
                        cps {
                          script('''
                            pipeline {
                              agent any
                              stages {
                                stage('Clone Repository') {
                                  steps {
                                    checkout([$class: 'GitSCM',
                                              branches: [[name: '*/main']],
                                              userRemoteConfigs: [[url: 'https://github.com/your-username/your-repo', credentialsId: 'github-credentials']]])
                                  }
                                }
                                stage('Deploy Application') {
                                  steps {
                                    script {
                                      def namespace = (env.BRANCH_NAME == 'main') ? 'prod' : 'dev'
                                      sh "helm upgrade --install myapp charts/myapp --namespace ${namespace}"
                                    }
                                  }
                                }
                              }
                            }
                          '''.stripIndent())
                        }
                      }
                    }
  EOT
  ]
}